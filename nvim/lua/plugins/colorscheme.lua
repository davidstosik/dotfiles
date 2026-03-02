-- Colorscheme: Tokyo Night
-- Matches the terminal (Ghostty) and tmux themes for a unified look.
-- https://github.com/folke/tokyonight.nvim

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",        -- "night" | "storm" | "day" | "moon"
      transparent = true,     -- matches terminal background opacity
      terminal_colors = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
