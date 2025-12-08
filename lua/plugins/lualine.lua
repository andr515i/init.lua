-- return {
--     "nvim-lualine/lualine.nvim",
--     opts = function(_, opts)
--         -- total number of lines in current buffer
--         local function total_lines()
--             local lines = vim.api.nvim_buf_line_count(0)
--             return "Ln " .. lines
--         end
--
--         -- total number of characters in current buffer
--         local function total_chars()
--             local wc = vim.fn.wordcount()
--             return "Ch " .. wc.chars
--         end
--
--         -- Put these on the right side of the statusline.
--         -- Adjust section (x/y/z) if you want a different position.
--         opts.sections.lualine_x = { total_lines, total_chars }
--         opts.sections.lualine_z = {}
--         opts.sections.lualine_y = {}
--     end,
-- }
--
--
--
--
--
--

return {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
        -- total number of lines in current buffer
        local function total_lines()
            local lines = vim.api.nvim_buf_line_count(0)
            return "Ln " .. lines
        end

        -- total number of characters in current buffer
        local function total_chars()
            local wc = vim.fn.wordcount()
            return "Ch " .. wc.chars
        end

        -- Macro recording indicator
        local function macro_recording()
            local reg = vim.fn.reg_recording()
            if reg == "" then
                return "" -- not recording
            else
                return "🔴recording @" .. reg
            end
        end

        -- Put these on the right side of the statusline.
        -- Our macro indicator will go to the left of total lines/chars.
        opts.sections.lualine_x = {
            macro_recording, -- <--- new
            total_lines,
            total_chars,
        }

        opts.sections.lualine_z = {}
        opts.sections.lualine_y = {}
    end,
}
