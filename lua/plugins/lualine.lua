return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus

		if vim.fn.argc(-1) > 0 then
			-- Empty statusline until lualine loads.
			vim.o.statusline = " "
		else
			-- Avoid statusline weirdness on starter/dashboard startup.
			vim.o.laststatus = 0
		end
	end,

	opts = function()
		vim.o.laststatus = vim.g.lualine_laststatus or 3

		return {
			options = {
				theme = "auto",
				globalstatus = vim.o.laststatus == 3,

				component_separators = {
					left = "│",
					right = "│",
				},

				section_separators = {
					left = "",
					right = "",
				},

				disabled_filetypes = {
					statusline = {
						"dashboard",
						"snacks_dashboard",
						"lazy",
						"mason",
						"neo-tree",
					},
					winbar = {},
				},
			},

			sections = {
				lualine_a = {
					"mode",
				},

				lualine_b = {
					"branch",
					{
						"diff",
						symbols = {
							added = "+",
							modified = "~",
							removed = "-",
						},
					},
				},

				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = {
							modified = " [+]",
							readonly = " [ro]",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
					},
				},

				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = {
							error = "E:",
							warn = "W:",
							info = "I:",
							hint = "H:",
						},
					},
					"encoding",
					"fileformat",
					"filetype",
				},

				lualine_y = {
					"progress",
				},

				lualine_z = {
					"location",
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = {
					"location",
				},
				lualine_y = {},
				lualine_z = {},
			},

			extensions = {
				"lazy",
				"mason",
				"neo-tree",
				"quickfix",
				"trouble",
			},
		}
	end,
}
