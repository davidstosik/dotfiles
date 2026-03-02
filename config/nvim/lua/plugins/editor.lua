-- Editor plugins — quality of life improvements
return {
  -- Comment.nvim — toggle comments (gc/gcc)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Auto pairs — automatically close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Surround — add/change/delete surrounding characters (ys, cs, ds)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Sleuth — auto-detect indentation
  {
    "tpope/vim-sleuth",
  },

  -- Fugitive — Git commands (:Git, :Gblame, etc.)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gblame", "Gdiff", "Glog" },
  },

  -- Endwise — automatically add `end` in Ruby, Lua, etc.
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- Trouble — better diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
    },
    opts = {},
  },

  -- Todo comments — highlight TODO, FIXME, etc.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
