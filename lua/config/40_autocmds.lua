local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})

-- Resize splits if window got resized.
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Close some filetypes with q.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"help",
		"qf",
		"man",
		"checkhealth",
		"lazy",
		"mason",
	},
	callback = function(event)
		vim.keymap.set("n", "q", "<cmd>close<CR>", {
			buffer = event.buf,
			silent = true,
			desc = "Close window",
		})
	end,
})

local function is_visible_buffer(bufnr)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			return true
		end
	end

	return false
end

local function tame_netrw(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	if vim.bo[bufnr].filetype ~= "netrw" then
		return
	end

	vim.bo[bufnr].buflisted = false
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	group = augroup,
	pattern = "*",
	callback = function(event)
		if vim.bo[event.buf].filetype == "netrw" then
			-- Schedule this so it wins after netrw/ftplugin has done its own setup.
			vim.schedule(function()
				tame_netrw(event.buf)
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup,
	pattern = "*",
	callback = function(event)
		if vim.bo[event.buf].filetype ~= "netrw" then
			return
		end

		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(event.buf) then
				return
			end

			if is_visible_buffer(event.buf) then
				return
			end

			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end)
	end,
})
