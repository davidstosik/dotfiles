return {
  {
    "lukas-reineke/headlines.nvim",
    event = "VeryLazy",
    ft = function()
      return {}
    end,
    opts = function(_, opts)
      local opts = {}
      for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
        opts[ft] = {
          headline_highlights = {},
          -- bullets = {},
          -- Change lower/upper headline string to use more supported characters
          -- see https://github.com/lukas-reineke/headlines.nvim/pull/89
          fat_headline_lower_string = "▔",
          fat_headline_upper_string = "▁",
        }
        for i = 1, 6 do
          local hl = "Headline" .. i
          vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
      end
      return opts
    end,
  },
}
