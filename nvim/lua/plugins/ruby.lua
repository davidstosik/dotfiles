-- Ruby-specific plugins and settings
-- LazyVim already includes ruby extras via lazyvim.plugins.extras.lang.ruby
-- (solargraph/rubocop LSP, treesitter, etc.) — add overrides here.

return {
  -- vim-rails: Rails-aware navigation, :Emodel, :Econtroller, etc.
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby" },
  },

  -- vim-bundler: aware of Gemfile, adds :Bundle command
  {
    "tpope/vim-bundler",
    ft = "ruby",
  },
}
