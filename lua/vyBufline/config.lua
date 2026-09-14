local M = {}

M.defaults = {
	align = "center",
	icons = true,
	separator = "",
	colors = {
		bg = "#0E1018",
		fg = "#C8D0E0",
		cyan = "#80C8E0",
		purple = "#B0A0D8",
		sage = "#90C8A0",
		peach = "#D0A888",
		gold = "#D4B878",
		rose = "#D0909C",
		teal = "#78B8B0",
		steel = "#8898B8",
		none = "none",
	},
	highlights = {},
}

M.opts = nil

function M.setup(user_config)
	M.opts = vim.tbl_deep_extend("force", M.defaults, user_config or {})

	local colors = M.defaults.colors

	local function apply_highlights()
		local base_hl = {
			vyBufOn = { fg = colors.fg, bg = colors.none, default = true },
			vyBufOff = { fg = colors.steel, bg = colors.none, default = true },
			vyBufSep = { fg = colors.fg, bg = colors.none, default = true },
			vyTabOn = { fg = colors.sage, bg = colors.none, default = true },
			vyTabOff = { fg = colors.steel, bg = colors.none, default = true },
			vyTabFill = { fg = colors.fg, bg = colors.none, default = true },
		}

		local final_hl = vim.tbl_deep_extend("force", base_hl, M.opts.highlights or {})

		for name, opts in pairs(final_hl) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end

	apply_highlights()

	-- Aucmd to reapply highlights on colorscheme change
	vim.api.nvim_create_augroup("vyBuflineColors", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = "vyBuflineColors",
		pattern = "*",
		callback = apply_highlights,
	})
end

function M.get()
	return M.opts or M.defaults
end

return M
