return {
    {
        "mfussenegger/nvim-jdtls",
        opts = function(_, opts)
            local default_root = opts.root_dir

            opts.root_dir = function(fname)
                -- Prefer the repo root / maven root (NOT the nearest pom.xml)
                local root = vim.fs.root(fname, { ".git", ".mvn", "mvnw" })
                if root then
                    return root
                end

                -- fallback to whatever nvim-jdtls wanted
                if type(default_root) == "function" then
                    return default_root(fname)
                end
            end
        end,
    },
}
