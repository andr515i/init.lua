return {
    {
        "mfussenegger/nvim-jdtls",
        opts = function(_, opts)
            local default_root = opts.root_dir
            local markers = {
                "aggregator/pom.xml",
                "parent-POM/pom.xml",
            }

            opts.root_dir = function(path)
                local match = vim.fs.find(markers, { path = path, upward = true })[1]
                if match then
                    local project_dir = vim.fs.dirname(match)
                    local repo_root = project_dir and vim.fs.dirname(project_dir)
                    if repo_root and repo_root ~= "" and vim.uv.fs_stat(repo_root .. "/.git") then
                        return repo_root
                    end
                    if project_dir and project_dir ~= "" then
                        return project_dir
                    end
                end
                if type(default_root) == "function" then
                    return default_root(path)
                end
                local root_markers = vim.lsp.config and vim.lsp.config.jdtls and vim.lsp.config.jdtls.root_markers
                if root_markers then
                    return vim.fs.root(path, root_markers)
                end
            end
        end,
    },
}
