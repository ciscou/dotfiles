return {
  {
    "catppuccin/nvim",
    opts = {
      custom_highlights = function(colors)
        return {
          Whitespace = { fg = colors.maroon },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },
}
