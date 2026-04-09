return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
        opts.filesystem = opts.filesystem or {}

        -- default behavior (you can set this to false if you want default OFF)
        opts.filesystem.group_empty_dirs = false
        -- recommended for VSCode-like collapsing
        opts.filesystem.scan_mode = "deep"

        opts.commands = opts.commands or {}

        opts.commands.toggle_group_empty_dirs = function(state)
            -- IMPORTANT: toggle the *state* value (this is what refresh/render uses)
            state.group_empty_dirs = not state.group_empty_dirs

            -- keep config in sync too (nice for future refreshes/new states)
            state.config = state.config or {}
            state.config.filesystem = state.config.filesystem or {}
            state.config.filesystem.group_empty_dirs = state.group_empty_dirs

            local function last_real_file()
                -- 1) if we're in a normal file buffer right now, use it
                local cur = vim.api.nvim_get_current_buf()
                local cur_ft = vim.bo[cur].filetype
                local cur_name = vim.api.nvim_buf_get_name(cur)
                if cur_name ~= "" and cur_ft ~= "neo-tree" then
                    return cur_name
                end

                -- 2) otherwise, use alternate buffer (#)
                local alt = vim.fn.bufnr("#")
                if alt > 0 and vim.api.nvim_buf_is_valid(alt) then
                    local alt_ft = vim.bo[alt].filetype
                    local alt_name = vim.api.nvim_buf_get_name(alt)
                    if alt_name ~= "" and alt_ft ~= "neo-tree" then
                        return alt_name
                    end
                end

                -- 3) last resort: scan for any listed file buffer
                for _, b in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.bo[b].buflisted and vim.bo[b].buftype == "" and vim.bo[b].filetype ~= "neo-tree" then
                        local name = vim.api.nvim_buf_get_name(b)
                        if name ~= "" then
                            return name
                        end
                    end
                end
            end
            -- force rebuild/refresh of the current source
            require("neo-tree.sources.manager").refresh(state.name)

            local cmd = require("neo-tree.command")
            local file = last_real_file()
            if file then
                cmd.execute({
                    source = "filesystem",
                    action = "focus",
                    reveal_file = file,
                    reveal_force_cwd = true,
                })
            end
            vim.notify("Neo-tree group_empty_dirs = " .. tostring(state.group_empty_dirs))
            vim.notify("current file:" .. file)
        end

        opts.window = opts.window or {}
        opts.window.mappings = opts.window.mappings or {}
        opts.window.mappings["g."] = "toggle_group_empty_dirs"
    end,
}
