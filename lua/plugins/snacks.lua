return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = {
            enabled = false,
        },
        indent = { enabled = true },
        input = { enabled = true },
        picker = {
            enabled = true,
        },

        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        images = {
            enabled = true,
            float = true,
            inline = true,
            env = { SNACKS_KITTY = true },
        },
    },
    layouts = {
        select = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.8,
            border = "none",
            box = "vertical",
            { win = "preview", title = "{preview}", height = 0.4, border = "rounded" },
            {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                title_pos = "center",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
            },
        },
    },
    keys = {
        {
            "<leader>E",
            function()
                require("snacks").explorer()
            end,
            desc = "open snacks explorer",
        },
        {
            "<leader>gb",
            function()
                require("snacks").picker.git_branches({ layout = "select" })
            end,
            desc = "pick git branch",
        },
        {
            "<leader>fk",
            function()
                require("snacks").picker.keymaps({})
            end,
            desc = "show and pick keymaps",
        },
    },
}
