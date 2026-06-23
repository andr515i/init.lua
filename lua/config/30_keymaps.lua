local map = vim.keymap.set

local function opts(desc)
  return {
    noremap = true,
    silent = true,
    desc = desc,
  }
end

-- Search movement: keep cursor centered.
map("n", "n", "nzzzv", opts("Next search result"))
map("n", "N", "Nzzzv", opts("Previous search result"))

-- Half-page movement: keep cursor centered.
map("n", "<C-d>", "<C-d>zz", opts("Half page down"))
map("n", "<C-u>", "<C-u>zz", opts("Half page up"))

-- Command mode ergonomics.
map({ "n", "v" }, ";", ":", { noremap = true, silent = false, desc = "Command mode" })
map({ "n", "v" }, "æ", ":", { noremap = true, silent = false, desc = "Command mode" })
map({ "n", "v" }, "Æ", ":", { noremap = true, silent = false, desc = "Command mode" })

-- Terminal escape.
map("t", "<Esc>", [[<C-\><C-n>]], opts("Exit terminal mode"))

-- Quickfix navigation.
map("n", "]q", "<cmd>cnext<CR>zz", opts("Next quickfix item"))
map("n", "[q", "<cmd>cprev<CR>zz", opts("Previous quickfix item"))
map("n", "<leader>qo", "<cmd>copen<CR>", opts("Open quickfix"))
map("n", "<leader>qc", "<cmd>cclose<CR>", opts("Close quickfix"))

-- Better visual repeat.
map("v", ".", ":normal .<CR>", opts("Repeat last normal command"))

-- Your old X = xp habit.
map("n", "X", "xp", opts("Transpose character forward"))

-- Force system clipboard mappings.
-- Useful when clipboard provider/SSH behavior needs explicit control.
map({ "n", "v" }, "<leader>y", [["+y]], opts("Yank to system clipboard"))
map("n", "<leader>Y", [["+Y]], opts("Yank line to system clipboard"))

-- Substitute word under cursor.
map("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  noremap = true,
  silent = false,
  desc = "Substitute word under cursor",
})

-- Substitute visual selection.
map("v", "<A-s>", [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><Left>]], {
  noremap = true,
  silent = false,
  desc = "Substitute selection",
})

-- Add linebreak after each selected line.
map("v", "<leader>va", ":s/$/<br>/<CR>", opts("Append <br> to selected lines"))
