local M = {}

M.defaults = {
	align = "center",
	icons = true,
	separator = "",
}

M.opts = nil

function M.setup(user_config)
	M.opts = vim.tbl_deep_extend("force", M.defaults, user_config or {})

	local hl = {
		vyBufOn = { link = "TabLineSel", default = true },
		vyBufOff = { link = "TabLine", default = true },
		vyBufSep = { link = "TabLine", default = true },
		vyTabOn = { link = "TabLineSel", default = true },
		vyTabOff = { link = "TabLine", default = true },
		vyTabFill = { link = "TabLineFill", default = true },
	}

	for name, opts in pairs(hl) do
		vim.api.nvim_set_hl(0, name, opts)
	end
end

function M.get()
	return M.opts or M.defaults
end

return M
