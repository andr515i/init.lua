return {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
        -- The default keymap to use for the quickfix window
        keymap = {
            -- The keymap to use for the quickfix window
            ["<C-n>"] = "next",
            ["<C-p>"] = "prev",
            ["<C-c>"] = "close",
            ["<C-q>"] = "quit",
            ["<C-s>"] = "save",
        },
    },
}
