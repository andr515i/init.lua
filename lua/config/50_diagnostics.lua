vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {
  desc = "Line diagnostics",
})

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, {
  desc = "Next diagnostic",
})

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, {
  desc = "Previous diagnostic",
})
