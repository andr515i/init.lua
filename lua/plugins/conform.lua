local function has_project_file(bufnr, names)
	local file = vim.api.nvim_buf_get_name(bufnr)
	local dir = vim.fs.dirname(file)

	if not dir then
		return false
	end

	local found = vim.fs.find(names, {
		upward = true,
		path = dir,
		stop = vim.loop.os_homedir(),
	})

	return #found > 0
end

local safe_autoformat_filetypes = {
	lua = true,

	javascript = true,
	javascriptreact = true,
	typescript = true,
	typescriptreact = true,

	json = true,
	jsonc = true,
	css = true,
	scss = true,
	html = true,
	yaml = true,

	sh = true,
	bash = true,
	fish = true,

	rust = true,
	python = true,

	markdown = true,
	markdown_inline = true,
}

local conditional_autoformat_filetypes = {
	c = {
		".clang-format",
	},
	cpp = {
		".clang-format",
	},
	cs = {
		".csharpier.json",
		".editorconfig",
	},
	sql = {
		".sql-formatter.json",
		".sqlfluff",
		".sqlfluffignore",
	},
	cmake = {
		".cmake-format.py",
		"cmake-format.yaml",
	},
}

local function should_autoformat(bufnr)
	if vim.g.disable_autoformat then
		return false
	end

	if vim.b[bufnr].disable_autoformat then
		return false
	end

	local ft = vim.bo[bufnr].filetype

	if safe_autoformat_filetypes[ft] then
		return true
	end

	local required_files = conditional_autoformat_filetypes[ft]
	if required_files and has_project_file(bufnr, required_files) then
		return true
	end

	return false
end

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	cmd = {
		"ConformInfo",
	},

	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
					lsp_format = "fallback",
				})
			end,
			mode = { "n", "v" },
			desc = "Format buffer/range",
		},
		{
			"<leader>cF",
			function()
				require("conform").format({
					async = true,
					lsp_format = "only",
				})
			end,
			mode = { "n", "v" },
			desc = "Format with LSP only",
		},
		{
			"<leader>uf",
			function()
				vim.b.disable_autoformat = not vim.b.disable_autoformat

				if vim.b.disable_autoformat then
					vim.notify("Autoformat disabled for this buffer")
				else
					vim.notify("Autoformat enabled for this buffer")
				end
			end,
			desc = "Toggle buffer autoformat",
		},
		{
			"<leader>uF",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat

				if vim.g.disable_autoformat then
					vim.notify("Autoformat disabled globally")
				else
					vim.notify("Autoformat enabled globally")
				end
			end,
			desc = "Toggle global autoformat",
		},
	},

	opts = {
		notify_on_error = true,
		notify_no_formatters = false,

		format_on_save = function(bufnr)
			if not should_autoformat(bufnr) then
				return nil
			end

			return {
				timeout_ms = 2000,
				lsp_format = "fallback",
			}
		end,

		formatters_by_ft = {
			-- Neovim/config
			lua = { "stylua" },

			-- Web
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },

			json = { "prettierd", "prettier", stop_after_first = true },
			jsonc = { "prettierd", "prettier", stop_after_first = true },

			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },

			markdown = { "prettierd", "prettier", stop_after_first = true },
			markdown_inline = { "prettierd", "prettier", stop_after_first = true },

			yaml = { "prettierd", "prettier", stop_after_first = true },

			-- Systems
			c = { "clang_format" },
			cpp = { "clang_format" },
			cmake = { "cmake_format" },
			rust = { "rustfmt" },

			-- Python
			python = { "isort", "black" },

			-- Shell/config
			sh = { "shfmt" },
			bash = { "shfmt" },
			fish = { "fish_indent" },

			-- SQL
			sql = { "sql_formatter", lsp_format = "fallback" },

			-- C#
			cs = { "csharpier", lsp_format = "fallback" },
		},
	},

	config = function(_, opts)
		require("conform").setup(opts)

		vim.api.nvim_create_user_command("Format", function(args)
			require("conform").format({
				async = true,
				lsp_format = args.bang and "only" or "fallback",
			})
		end, {
			bang = true,
			desc = "Format current buffer. Use :Format! for LSP-only formatting.",
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.g.disable_autoformat = true
				vim.notify("Autoformat disabled globally")
			else
				vim.b.disable_autoformat = true
				vim.notify("Autoformat disabled for this buffer")
			end
		end, {
			bang = true,
			desc = "Disable autoformat. Use :FormatDisable! globally.",
		})

		vim.api.nvim_create_user_command("FormatEnable", function(args)
			if args.bang then
				vim.g.disable_autoformat = false
				vim.notify("Autoformat enabled globally")
			else
				vim.b.disable_autoformat = false
				vim.notify("Autoformat enabled for this buffer")
			end
		end, {
			bang = true,
			desc = "Enable autoformat. Use :FormatEnable! globally.",
		})

		vim.api.nvim_create_user_command("FormatToggle", function(args)
			if args.bang then
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				vim.notify("Global autoformat: " .. (vim.g.disable_autoformat and "off" or "on"))
			else
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				vim.notify("Buffer autoformat: " .. (vim.b.disable_autoformat and "off" or "on"))
			end
		end, {
			bang = true,
			desc = "Toggle autoformat. Use :FormatToggle! globally.",
		})
	end,
}
