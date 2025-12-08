return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = false, -- no ghost text unless you ask for it
                trigger_on_accept = false, -- don't trigger suggestions when pressing accept if none visible
                keymap = {
                    accept = "<C-j>", -- accept current suggestion
                    next = "<M-,>", -- ⟵ press this to TRIGGER a suggestion
                    prev = "<M-.>", -- cycle backwards (also triggers)
                    dismiss = "<M-/>", -- hide suggestion
                },
            },
            panel = { enabled = true },
        })
        --
    end,
}
