return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"clangd",
				"pyright",
				"ts_ls",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
			},

			-- Important:
			-- We do NOT let mason-lspconfig auto-enable everything.
			-- We enable servers ourselves in lua/config/60_lsp.lua.
			automatic_enable = false,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			ensure_installed = {
				-- Lua
				"stylua",

				-- Web
				"prettier",
				"prettierd",

				-- C/C++
				"cmakelang",

				-- Python
				"black",
				"isort",

				-- Shell
				"shfmt",

				-- SQL
				"sql-formatter",

				-- C#
				"csharpier",

				-- Debug adapters
				"codelldb",
				"debugpy",
				"netcoredbg",
			},

			auto_update = false,
			run_on_start = true,
			start_delay = 3000,
			debounce_hours = 24,
		},
	},
}
