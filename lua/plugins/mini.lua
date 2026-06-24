return {
	"echasnovski/mini.nvim",
	version = false,
	event = "VeryLazy",

	config = function()
		require("mini.comment").setup({
			mappings = {
				comment = "gc",
				comment_line = "gcc",
				comment_visual = "gc",
				textobject = "gc",
			},
		})

		require("mini.surround").setup({
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		})

		require("mini.pairs").setup({
			modes = {
				insert = true,
				command = false,
				terminal = false,
			},
		})

		local ai = require("mini.ai")
		local extra = require("mini.extra")

		require("mini.extra").setup()

		require("mini.ai").setup({
			n_lines = 500,

			custom_textobjects = {
				-- LazyVim-style buffer textobject.
				-- vag = select whole file
				-- vig = select whole file without leading/trailing blank lines
				g = extra.gen_ai_spec.buffer(),

				-- LazyVim-style Treesitter textobjects.
				-- vao / vio = block/conditional/loop
				o = ai.gen_spec.treesitter({
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),

				-- vaf / vif = function
				f = ai.gen_spec.treesitter({
					a = "@function.outer",
					i = "@function.inner",
				}),

				-- vac / vic = class
				c = ai.gen_spec.treesitter({
					a = "@class.outer",
					i = "@class.inner",
				}),

				-- vat / vit = tag
				t = {
					"<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
					"^<.->().*()</[^/]->$",
				},

				-- vad / vid = digits
				d = {
					"%f[%d]%d+",
				},

				-- vae / vie = word with case
				e = {
					{
						"%u[%l%d]+%f[^%l%d]",
						"%f[%S][%l%d]+%f[^%l%d]",
						"%f[%P][%l%d]+%f[^%l%d]",
						"^[%l%d]+%f[^%l%d]",
					},
					"^().*()$",
				},

				-- vau / viu = function call / usage
				u = ai.gen_spec.function_call(),

				-- vaU / viU = function call without dot in function name
				U = ai.gen_spec.function_call({
					name_pattern = "[%w_]",
				}),

				-- Extra useful textobjects from mini.extra.
				-- val / vil = current line
				l = extra.gen_ai_spec.line(),

				-- vai / vii = indent scope
				i = extra.gen_ai_spec.indent(),

				-- van / vin = number
				n = extra.gen_ai_spec.number(),

				-- vax / vix = diagnostic
				x = extra.gen_ai_spec.diagnostic(),
			},
		})
	end,
}
