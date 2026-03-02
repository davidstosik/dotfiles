-- Bootstrap lazy.nvim plugin manager
-- Clones lazy.nvim on first launch if not present

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim base — opinionated defaults, great for daily use
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Extras — opt into what you actually use
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.yanky" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.ruby" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },

    -- Your custom plugins (see lua/plugins/)
    { import = "plugins" },
  },
  defaults = {
    -- Don't lazy-load by default for snappy startups
    lazy = false,
    -- Use latest stable versions
    version = false,
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    -- Automatically check for plugin updates (notification only)
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      -- Disable unused built-in plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
