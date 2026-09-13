-- vyBufline/plugin/vyBufline.lua
-- Auto-setup: only runs if user hasn't called setup() yet
if vim.g.loaded_vyBufline then
	return
end
vim.g.loaded_vyBufline = true

vim.api.nvim_create_autocmd("User", {
	pattern = "DeferredLoaded",
	once = true,
	callback = function()
		local ok, bufline = pcall(require, "vyBufline")
		if ok and not require("vyBufline.config").opts then
			bufline.setup()
		end
	end,
})
