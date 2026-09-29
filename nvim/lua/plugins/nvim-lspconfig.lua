return {
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "ruby" } } },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          init_options = {
            addonSettings = {
              ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = false,
              },
            },
          },
        },
      },
    },
  },
}
