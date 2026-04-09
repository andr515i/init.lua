local M = {}
local theme = require("user.themes.chromognomev2.theme")

M.setup = function()
    vim.cmd("hi clear")

    vim.o.background = "dark"
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.termguicolors = true
    vim.g.colors_name = "chromognome_dark"

    theme.set_highlights()
end

return M
