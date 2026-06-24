return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },

		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},

			signs_staged_enable = true,

			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,

			watch_gitdir = {
				follow_files = true,
			},

			attach_to_untracked = true,

			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 700,
				ignore_whitespace = false,
			},

			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},

			on_attach = function(bufnr)
				local gs = require("gitsigns")

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, {
						buffer = bufnr,
						silent = true,
						desc = desc,
					})
				end

				-- Hunk navigation.
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next git hunk")

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Previous git hunk")

				-- Hunk actions.
				map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>ghs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage selected hunk")
				map("v", "<leader>ghr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset selected hunk")

				map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")

				map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>ghP", gs.preview_hunk_inline, "Preview hunk inline")

				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, "Blame line")

				map("n", "<leader>ghd", gs.diffthis, "Diff this")
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, "Diff this against previous")

				-- Toggles.
				map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle git blame")
				map("n", "<leader>gtd", gs.toggle_deleted, "Toggle deleted lines")
				map("n", "<leader>gtw", gs.toggle_word_diff, "Toggle word diff")

				-- Textobject.
				map({ "o", "x" }, "ih", gs.select_hunk, "Git hunk")
			end,
		},
	},

	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewFileHistory",
			"DiffviewRefresh",
		},

		keys = {
			{
				"<leader>gd",
				"<cmd>DiffviewOpen<CR>",
				desc = "Diffview open",
			},
			{
				"<leader>gD",
				"<cmd>DiffviewOpen HEAD~1..HEAD<CR>",
				desc = "Diffview last commit",
			},
			{
				"<leader>gq",
				"<cmd>DiffviewClose<CR>",
				desc = "Diffview close",
			},
			{
				"<leader>ghf",
				"<cmd>DiffviewFileHistory %<CR>",
				desc = "File history",
			},
			{
				"<leader>ghH",
				"<cmd>DiffviewFileHistory<CR>",
				desc = "Repo history",
			},
		},

		opts = {
			enhanced_diff_hl = true,
			view = {
				default = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_horizontal",
					disable_diagnostics = true,
				},
				file_history = {
					layout = "diff2_horizontal",
				},
			},
			file_panel = {
				listing_style = "tree",
				tree_options = {
					flatten_dirs = true,
					folder_statuses = "only_folded",
				},
				win_config = {
					position = "left",
					width = 35,
				},
			},
		},
	},

	{
		"rhysd/conflict-marker.vim",
		event = { "BufReadPost", "BufNewFile" },

		init = function()
			vim.g.conflict_marker_enable_mappings = 0

			vim.g.conflict_marker_highlight_group = ""

			vim.g.conflict_marker_begin = "^<<<<<<< .*$"
			vim.g.conflict_marker_common_ancestors = "^||||||| .*$"
			vim.g.conflict_marker_separator = "^=======$"
			vim.g.conflict_marker_end = "^>>>>>>> .*$"
		end,

		keys = {
			{
				"]x",
				"<cmd>ConflictMarkerNextHunk<CR>",
				desc = "Next conflict",
			},
			{
				"[x",
				"<cmd>ConflictMarkerPrevHunk<CR>",
				desc = "Previous conflict",
			},
			{
				"<leader>gco",
				"<cmd>ConflictMarkerOurselves<CR>",
				desc = "Conflict choose ours",
			},
			{
				"<leader>gct",
				"<cmd>ConflictMarkerThemselves<CR>",
				desc = "Conflict choose theirs",
			},
			{
				"<leader>gcb",
				"<cmd>ConflictMarkerBoth<CR>",
				desc = "Conflict choose both",
			},
			{
				"<leader>gc0",
				"<cmd>ConflictMarkerNone<CR>",
				desc = "Conflict choose none",
			},
		},
	},
}
