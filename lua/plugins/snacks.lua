return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = false },
        images = {
            enabled = true,
            float = true,
            inline = true,
            env = { SNACKS_KITTY = true },
        },
    },

    config = function(_, opts)
        require("snacks").setup(opts)

        -- make the picker text use your Normal fg (usually white)
        local set_hl = vim.api.nvim_set_hl
        set_hl(0, "SnacksPickerDesc", { link = "Normal" })
        set_hl(0, "SnacksPickerText", { link = "Normal" })
    end,

    layouts = {
        select = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.8,
            border = "none",
            box = "vertical",
            {
                win = "preview",
                title = "{preview}",
                height = 0.4,
                border = "rounded",
            },
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
            "<leader>fk",
            function()
                local Snacks = require("snacks")

                Snacks.picker.keymaps({
                    format = function(item)
                        local k = item.item
                        local a = Snacks.picker.util.align
                        local ret = {}

                        -- icon
                        local icon = " "
                        local icon_hl
                        if package.loaded["which-key"] then
                            local Icons = require("which-key.icons")
                            local i, hl = Icons.get({ keymap = k, desc = k.desc })
                            if i then
                                icon, icon_hl = i, hl
                            end
                        end
                        ret[#ret + 1] = { a(icon, 3), icon_hl }

                        -- mode
                        ret[#ret + 1] = { " " }
                        ret[#ret + 1] = { k.mode, "SnacksPickerKeymapMode" }

                        -- lhs
                        local lhs = Snacks.util.normkey(k.lhs)
                        ret[#ret + 1] = { " " }
                        ret[#ret + 1] = { a(lhs, 15), "SnacksPickerKeymapLhs" }

                        -- desc
                        ret[#ret + 1] = { " " }
                        ret[#ret + 1] = { k.desc or "", "SnacksPickerDesc" }

                        return ret
                    end,
                })
            end,
            desc = "Show keymaps (icon, mode, lhs, desc)",
        },
    },
}
