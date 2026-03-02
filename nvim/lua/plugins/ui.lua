-- UI tweaks

return {
  -- Markdown headlines (bold, colored headers in Markdown files)
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {},
  },
}
