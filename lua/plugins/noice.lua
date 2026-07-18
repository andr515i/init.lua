return {
	"folke/noice.nvim",
	event = "VeryLazy",

	dependencies = {
		"MunifTanjim/nui.nvim",
	},

	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",

			format = {
				cmdline = {
					pattern = "^:",
					icon = "",
					lang = "vim",
				},
				search_down = {
					kind = "search",
					pattern = "^/",
					icon = " ",
					lang = "regex",
				},
				search_up = {
					kind = "search",
					pattern = "^%?",
					icon = " ",
					lang = "regex",
				},
				filter = {
					pattern = "^:%s*!",
					icon = "$",
					lang = "fish",
				},
				lua = {
					pattern = "^:%s*lua%s+",
					icon = "",
					lang = "lua",
				},
			},
		},

		messages = {
			enabled = true,
			view = "mini",
			view_error = "mini",
			view_warn = "mini",
			view_history = "messages",
			view_search = "virtualtext",
		},

		popupmenu = {
			enabled = true,
		},

		notify = {
			enabled = false,
		},

		lsp = {
			progress = {
				enabled = false,
			},
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false,
			},
			hover = {
				enabled = false,
			},
			signature = {
				enabled = false,
			},
		},

		presets = {
			bottom_search = false,
			command_palette = false,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = false,
		},

		routes = {
			{
				filter = {
					event = "msg_show",
					find = "%d+L, %d+B",
				},
				opts = {
					skip = true,
				},
			},
		},
	},

	config = function(_, opts)
		vim.opt.showmode = false
		require("noice").setup(opts)
	end,

	keys = {
		{
			"<leader>sn",
			"<cmd>Noice<CR>",
			desc = "Noice messages",
		},
		{
			"<leader>sN",
			"<cmd>NoiceAll<CR>",
			desc = "Noice all messages",
		},
		{
			"<leader>nd",
			"<cmd>NoiceDismiss<CR>",
			desc = "Dismiss Noice messages",
		},
	},
}
