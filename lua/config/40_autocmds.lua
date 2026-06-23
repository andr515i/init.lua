local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Resize splits if window got resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Close some filetypes with q.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "help",
    "qf",
    "man",
    "checkhealth",
    "lazy",
    "mason",
  },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})
