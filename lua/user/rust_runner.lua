-- ~/.config/nvim/lua/user/rust_runner.lua
local api = vim.api
local Terminal = require("toggleterm.terminal").Terminal

-- will hold the window you were in before we open the terminal
local prev_win = nil

-- define a one-off terminal for `cargo run`
local cargo_term = Terminal:new({
    cmd = "cargo run",
    hidden = true,
    close_on_exit = true,

    -- fire after the terminal buffer actually closes
    on_close = function()
        if prev_win and api.nvim_win_is_valid(prev_win) then
            api.nvim_set_current_win(prev_win)
        end
        prev_win = nil
    end,
})

-- expose a single function to toggle it
local M = {}
function M.run()
    -- remember which window is active right now
    prev_win = api.nvim_get_current_win()
    -- open (or close) the cargo terminal
    cargo_term:toggle()
end

return M
