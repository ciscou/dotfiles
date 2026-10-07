return {
  "tpope/vim-rails",
  ft = { "ruby", "eruby" },
  config = function()
    vim.keymap.set("n", "<leader>ra", ":A<CR>", { desc = "Rails Alternate" })
    vim.keymap.set("n", "<leader>rr", ":R<CR>", { desc = "Rails Related" })
    vim.keymap.set("n", "<leader>rm", ":Emodel<CR>", { desc = "Rails Model" })
    vim.keymap.set("n", "<leader>rc", ":Econtroller<CR>", { desc = "Rails Controller" })
    vim.keymap.set("n", "<leader>rv", ":Eview<CR>", { desc = "Rails View" })
  end,
}
