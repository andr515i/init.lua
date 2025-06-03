return {
    "echasnovski/mini.splitjoin",
    config = function()
        local sj = require("mini.splitjoin")
        sj.setup({
            mappings = { toggle = "" },
        })
        vim.keymap.set({ "n", "x" }, "<leader>sk", function()
            sj.split()
        end, { desc = "split lines" })
        vim.keymap.set({ "n", "x" }, "<leader>sj", function()
            sj.join()
        end, { desc = "join lines" })
    end,
}
