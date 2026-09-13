local M = {}
local api = vim.api
local segments = require("vyBufline.segments")
local explorer = require("vyBufline.explorer")
local mode = require("vyBufline.mode")
local config = require("vyBufline.config")

local PREFIX_TEXT = "  "
local PREFIX_WIDTH = vim.fn.strwidth(PREFIX_TEXT)

local function explorer_pad(used)
	local width = explorer.get_explorer_width()
	if width <= used then
		return ""
	end
	return "%#vyTabFill#" .. string.rep(" ", width - used)
end

function M.generate()
	local align = config.get().align

	local bufs = vim.tbl_filter(api.nvim_buf_is_valid, vim.t.bufs or {})
	vim.t.bufs = bufs
	local cur_buf = api.nvim_get_current_buf()
	if not vim.tbl_contains(bufs, cur_buf) then
		cur_buf = vim.t.last_buf or (bufs[1] or cur_buf)
	end

	local buf_parts = {}
	for _, nr in ipairs(bufs) do
		buf_parts[#buf_parts + 1] = segments.render_buf(nr, nr == cur_buf)
	end

	local tabpages = api.nvim_list_tabpages()
	local tab_parts = {}
	local cur_tab = api.nvim_get_current_tabpage()
	for _, tabid in ipairs(tabpages) do
		local nr = api.nvim_tabpage_get_number(tabid)
		tab_parts[#tab_parts + 1] = segments.render_tab(nr, tabid == cur_tab)
	end

	local buffers = table.concat(buf_parts)
	local tabs = table.concat(tab_parts)

	local hl = mode.hl(api.nvim_get_mode().mode)
	local prefix = "%#" .. hl .. "#" .. PREFIX_TEXT .. explorer_pad(PREFIX_WIDTH)

	if align == "center" then
		return prefix .. "%#vyTabFill#%=" .. buffers .. "%#vyTabFill#%=" .. tabs
	elseif align == "right" then
		return prefix .. "%#vyTabFill#%=" .. buffers .. " " .. tabs
	end

	return prefix .. buffers .. "%#vyTabFill#%=" .. tabs
end

local function find_buf(bufnr)
	for i, b in ipairs(vim.t.bufs or {}) do
		if b == bufnr then
			return i
		end
	end
end

function M.next()
	local bufs = vim.t.bufs or {}
	if #bufs < 2 then
		return
	end
	local i = find_buf(api.nvim_get_current_buf()) or 0
	api.nvim_set_current_buf(bufs[i % #bufs + 1])
end

function M.prev()
	local bufs = vim.t.bufs or {}
	if #bufs < 2 then
		return
	end
	local i = find_buf(api.nvim_get_current_buf()) or 2
	api.nvim_set_current_buf(bufs[(i - 2) % #bufs + 1])
end

function M.close_buf(bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()

	if vim.bo[bufnr].buftype == "terminal" then
		vim.cmd(vim.bo.buflisted and "setlocal nobuflisted | enew" or "hide")
		return
	end

	if api.nvim_win_get_config(0).zindex then
		vim.cmd("bw")
		return
	end

	local bufs = vim.t.bufs or {}
	local idx = find_buf(bufnr)

	if idx and #bufs > 1 then
		api.nvim_set_current_buf(bufs[idx == #bufs and idx - 1 or idx + 1])
	elseif not vim.bo[bufnr].buflisted then
		if bufs[1] then
			local winid = vim.fn.bufwinid(bufs[1])
			if winid ~= -1 then
				api.nvim_set_current_win(winid)
			end
			api.nvim_set_current_buf(bufs[1])
		end
		vim.cmd("bw" .. bufnr)
		vim.cmd("redrawtabline")
		return
	else
		vim.cmd("enew")
	end

	if vim.bo[bufnr].bufhidden ~= "delete" and api.nvim_buf_is_valid(bufnr) then
		vim.cmd("confirm bd" .. bufnr)
	end

	vim.cmd("redrawtabline")
end

function M.close_all(keep_current)
	local cur = api.nvim_get_current_buf()
	for _, b in ipairs(vim.t.bufs or {}) do
		if not keep_current or b ~= cur then
			M.close_buf(b)
		end
	end
end

function M.shift_buf(dir)
	local bufs = vim.t.bufs or {}
	local i = find_buf(api.nvim_get_current_buf())
	if not i then
		return
	end
	local j = ((i - 1 + dir) % #bufs) + 1
	bufs[i], bufs[j] = bufs[j], bufs[i]
	vim.t.bufs = bufs
	vim.cmd("redrawtabline")
end

function M.focus_buf(bufnr)
	local win = api.nvim_get_current_win()
	if api.nvim_get_option_value("winfixbuf", { win = win }) then
		for _, w in ipairs(api.nvim_list_wins()) do
			if
				not api.nvim_get_option_value("winfixbuf", { win = w })
				and api.nvim_get_option_value("buflisted", { buf = api.nvim_win_get_buf(w) })
			then
				api.nvim_set_current_win(w)
				break
			end
		end
	end
	api.nvim_set_current_buf(bufnr)
end

function M.setup(user_config)
	config.setup(user_config)

	local augroup = api.nvim_create_augroup("vyBufline", { clear = true })

	vim.t.bufs = vim.t.bufs
		or vim.tbl_filter(function(b)
			if vim.fn.buflisted(b) ~= 1 then
				return false
			end
			return api.nvim_buf_get_name(b) ~= "" or api.nvim_get_option_value("modified", { buf = b })
		end, api.nvim_list_bufs())

	vim.o.showtabline = 2
	vim.o.tabline = "%!v:lua.require('vyBufline').generate()"

	api.nvim_create_autocmd("ModeChanged", {
		group = augroup,
		callback = function()
			vim.cmd("redrawtabline")
		end,
	})

	api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		callback = function(args)
			local buf = args.buf
			if api.nvim_buf_is_valid(buf) and api.nvim_get_option_value("buflisted", { buf = buf }) then
				vim.t.last_buf = buf
			end
		end,
	})

	api.nvim_create_autocmd("tabnew", {
		group = augroup,
		callback = function()
			vim.t.bufs = {}
		end,
	})

	api.nvim_create_autocmd({ "BufAdd", "BufEnter" }, {
		group = augroup,
		callback = function(args)
			local buf = args.buf
			if not api.nvim_buf_is_valid(buf) then
				return
			end
			if not api.nvim_get_option_value("buflisted", { buf = buf }) then
				return
			end
			if vim.v.vim_did_enter == 0 and api.nvim_buf_get_name(buf) == "" then
				return
			end

			local bufs = vim.t.bufs or {}
			if vim.tbl_contains(bufs, buf) then
				return
			end

			table.insert(bufs, buf)

			if
				#bufs > 1
				and api.nvim_buf_get_name(bufs[1]) == ""
				and not api.nvim_get_option_value("modified", { buf = bufs[1] })
			then
				table.remove(bufs, 1)
			end

			vim.t.bufs = bufs
		end,
	})

	api.nvim_create_autocmd("BufDelete", {
		group = augroup,
		callback = function(args)
			for _, tab in ipairs(api.nvim_list_tabpages()) do
				local bufs = vim.t[tab].bufs or {}
				for i, b in ipairs(bufs) do
					if b == args.buf then
						table.remove(bufs, i)
						vim.t[tab].bufs = bufs
						break
					end
				end
			end
		end,
	})

	api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = "qf",
		callback = function()
			vim.opt_local.buflisted = false
		end,
	})

	vim.cmd([[
    function! VyGoToBuf(bufnr,b,c,d)
      call luaeval('require("vyBufline").focus_buf(_A)', a:bufnr)
    endfunction
    function! VyGotoTab(tabnr,b,c,d)
      execute a:tabnr .. 'tabnext'
    endfunction
  ]])
end

return M
