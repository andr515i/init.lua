return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	opts = {
		focus = true,
		auto_close = false,
		auto_preview = true,
		auto_refresh = true,
		use_diagnostic_signs = true,

		modes = {
			diagnostics = {
				groups = {
					{ "filename", format = "{file_icon} {basename:Title} {count}" },
				},
			},
			symbols = {
				win = {
					position = "right",
					size = 45,
				},
			},
		},
	},

	keys = {
		-- Diagnostics
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<CR>",
			desc = "Diagnostics",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Buffer diagnostics",
		},

		-- Symbols / LSP
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<CR>",
			desc = "Document symbols",
		},
		{
			"<leader>cS",
			"<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
			desc = "LSP definitions/references",
		},

		-- Lists
		{
			"<leader>xq",
			"<cmd>Trouble qflist toggle<CR>",
			desc = "Quickfix list",
		},
		{
			"<leader>xl",
			"<cmd>Trouble loclist toggle<CR>",
			desc = "Location list",
		},
	},
}
