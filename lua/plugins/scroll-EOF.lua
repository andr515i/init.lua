return {
	"Aasim-A/scrollEOF.nvim",
	event = { "CursorMoved", "WinScrolled" },

	opts = {
		-- Keep roughly this many virtual/empty lines below EOF.
		pattern = "*",
		insert_mode = true,
		floating = false,
		disabled_filetypes = {
			"neo-tree",
			"snacks_dashboard",
			"dashboard",
			"lazy",
			"mason",
			"Trouble",
			"qf",
			"help",
			"terminal",
		},
	},
}
