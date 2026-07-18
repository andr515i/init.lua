-- lua/plugins/leetcode.lua

return {
	{
		"kawre/leetcode.nvim",
		cmd = "Leet",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"folke/snacks.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			lang = "cpp",

			picker = {
				provider = "snacks-picker",
			},

			plugins = {
				-- Important: lets you use leetcode.nvim from a normal nvim session,
				-- not only from `nvim leetcode.nvim` / empty dashboard state.
				non_standalone = true,
			},

			console = {
				open_on_runcode = true,
			},
		},
		keys = {
			{
				"<leader>lr",
				"<cmd>Leet run<cr>",
				desc = "LeetCode: run",
			},
			{
				"<leader>lt",
				"<cmd>Leet test<cr>",
				desc = "LeetCode: test",
			},
			{
				"<leader>ls",
				"<cmd>Leet submit<cr>",
				desc = "LeetCode: submit",
			},
			{
				"<leader>ll",
				"<cmd>Leet lang<cr>",
				desc = "LeetCode: language",
			},

			-- Not in your requested list, but you need some entry point.
			-- Remove this if you only want to use `:Leet` manually.
			{
				"<leader>lm",
				"<cmd>Leet<cr>",
				desc = "LeetCode: menu",
			},
			{
				"<leader>lq",
				"<cmd>Leet list<cr>",
				desc = "LeetCode: questions",
			},
		},
	},
}
