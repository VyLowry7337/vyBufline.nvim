# vyBufline.nvim

A standalone bufferline (tabline) for Neovim.
Optional dependencies — works with any theme out of the box.

## Installation

**lazy.nvim**

```lua
{
  "VyLowry7337/vyBufline.nvim",
  event = "VeryLazy",
  config = function()
    require("vyBufline").setup()
  end,
}
```

**vim.pack**

```bash
git clone https://github.com/VyLowry7337/vyBufline.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/vyBufline.nvim
```

Then in your config:
```lua
require("vyBufline").setup()
```

No other plugins are required.
`nvim-web-devicons` is optional — install it if you want filetype icons.

## Configuration

```lua
require("vyBufline").setup({
  align = "center",   -- "left" | "center" | "right"
  icons = true,       -- show nvim-web-devicons icons (false to disable)
  separator = "",     -- separator between buffers
})
```

All highlights use the `vy` prefix and link to standard groups (`TabLineSel`,
`TabLine`, `Directory`, etc.), so they work with almost any colorscheme.
Override them in your config if needed:

```lua
vim.api.nvim_set_hl(0, "vyBufOn", { fg = "#ffffff", bg = "#000000" })
```

## PR's Welcome

Found a bug or want a feature?
Open a PR — contributions are welcome.
