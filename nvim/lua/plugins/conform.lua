return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      shfmt_zsh = {
        inherit = false,
        command = "shfmt",
        args = { "-ln", "zsh", "-i", "2", "-filename", "$FILENAME" },
        stdin = true,
      },
    },
    formatters_by_ft = {
      zsh = { "shfmt_zsh" },
    },
  },
}
