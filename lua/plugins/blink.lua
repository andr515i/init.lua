return {
    "saghen/blink.cmp",
    opts = function(_, opts)
        vim.b.completion = true
        Snacks.toggle({
            name = "Completion",
            get = function()
                return vim.b.completion
            end,
            set = function(state)
                vim.b.completion = state
            end,
        }):map("<leader>uk")

        opts.enabled = function()
            return vim.b.completion ~= false
        end

        -- Snippets engine
        opts.snippets = opts.snippets or {}
        opts.snippets.preset = "luasnip"

        -- 🔴 Force source order: snippets before lsp
        opts.sources = opts.sources or {}
        opts.sources.default = { "snippets", "lsp", "path", "buffer" }

        -- we'll tweak scoring next
        opts.sources.providers = opts.sources.providers or {}

        -- Give snippets a big boost
        opts.sources.providers.snippets = vim.tbl_deep_extend("force", opts.sources.providers.snippets or {}, {
            score_offset = 20, -- tweak this up/down until it feels right
        })

        return opts
    end,
}
