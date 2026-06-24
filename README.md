Known weirdness:
- On Windows Terminal / PowerShell, Neovim briefly rendered repeated lualine/status text in the lower buffer area.
- File content was not actually modified.
- Restart fixed it.
- Suspects: cmdheight=0, Noice/cmdline UI, Windows Terminal redraw, or temporary statusline redraw bug.
- If it returns: set cmdheight=1, disable Noice, restart, then retest.
