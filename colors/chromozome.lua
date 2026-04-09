vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "chromozome"

local p = {
    bg = "#040404",
    bg_alt = "#16161d",
    bg_highlight = "#22222b",

    fg = "#f2f2f7",
    fg_muted = "#a7a7b3",

    accent = "#9f1ff0",
    accent_soft = "#c22cff",

    border = "#2b2433",
}

local set = vim.api.nvim_set_hl

local function hl(group, opts)
    set(0, group, opts)
end

-- Core editor
hl("Normal", { fg = p.fg, bg = p.bg })
hl("NormalFloat", { fg = p.fg, bg = p.bg_alt })
hl("FloatBorder", { fg = p.border, bg = p.bg_alt })
hl("CursorLine", { bg = p.bg_alt })
hl("CursorColumn", { bg = p.bg_alt })
hl("ColorColumn", { bg = p.bg_alt })
hl("CursorLineNr", { fg = p.accent, bold = true })
hl("LineNr", { fg = p.fg_muted })
hl("SignColumn", { bg = p.bg })
hl("EndOfBuffer", { fg = p.bg, bg = p.bg })

-- Splits / windows
hl("WinSeparator", { fg = p.border })
hl("VertSplit", { fg = p.border })

-- Status/tab
hl("StatusLine", { fg = p.fg, bg = p.bg_alt })
hl("StatusLineNC", { fg = p.fg_muted, bg = p.bg_alt })
hl("TabLine", { fg = p.fg_muted, bg = p.bg_alt })
hl("TabLineFill", { bg = p.bg_alt })
hl("TabLineSel", { fg = p.accent, bg = p.bg, bold = true })

-- Selection / search
hl("Visual", { bg = p.bg_highlight })
hl("Search", { fg = p.bg, bg = p.accent_soft, bold = true })
hl("IncSearch", { fg = p.bg, bg = p.accent, bold = true })
hl("CurSearch", { fg = p.bg, bg = p.accent, bold = true })
hl("MatchParen", { fg = p.accent, bold = true, underline = true })

-- Popup menu
hl("Pmenu", { fg = p.fg, bg = p.bg_alt })
hl("PmenuSel", { fg = p.bg, bg = p.accent })
hl("PmenuSbar", { bg = p.bg_highlight })
hl("PmenuThumb", { bg = p.fg_muted })

-- Messages
hl("ErrorMsg", { fg = p.accent, bold = true })
hl("WarningMsg", { fg = p.accent_soft, bold = true })
hl("MoreMsg", { fg = p.accent })
hl("ModeMsg", { fg = p.accent, bold = true })
hl("Question", { fg = p.accent })

-- Syntax
hl("Comment", { fg = p.fg_muted, italic = true })

hl("Constant", { fg = p.fg })
hl("String", { fg = p.fg })
hl("Character", { fg = p.fg })
hl("Number", { fg = p.fg })
hl("Boolean", { fg = p.accent_soft, bold = true })
hl("Float", { fg = p.fg })

hl("Identifier", { fg = p.fg })
hl("Function", { fg = p.accent })

hl("Statement", { fg = p.accent, bold = true })
hl("Conditional", { fg = p.accent, bold = true })
hl("Repeat", { fg = p.accent, bold = true })
hl("Label", { fg = p.accent })
hl("Operator", { fg = p.fg })
hl("Keyword", { fg = p.accent, bold = true })
hl("Exception", { fg = p.accent })

hl("PreProc", { fg = p.accent_soft })
hl("Include", { fg = p.accent })
hl("Define", { fg = p.accent })
hl("Macro", { fg = p.accent_soft })
hl("PreCondit", { fg = p.accent_soft })

hl("Type", { fg = p.accent_soft })
hl("StorageClass", { fg = p.accent_soft })
hl("Structure", { fg = p.accent_soft })
hl("Typedef", { fg = p.accent_soft })

hl("Special", { fg = p.fg })
hl("SpecialChar", { fg = p.fg })
hl("Tag", { fg = p.accent })
hl("Delimiter", { fg = p.fg_muted })
hl("SpecialComment", { fg = p.fg_muted, italic = true })
hl("Debug", { fg = p.accent })

-- Diagnostics
hl("DiagnosticError", { fg = p.accent })
hl("DiagnosticWarn", { fg = p.accent_soft })
hl("DiagnosticInfo", { fg = p.fg })
hl("DiagnosticHint", { fg = p.fg_muted })

hl("DiagnosticUnderlineError", { undercurl = true, sp = p.accent })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.accent_soft })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.fg })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.fg_muted })

-- Diff / git
hl("DiffAdd", { bg = "#15151c" })
hl("DiffChange", { bg = "#1d1a24" })
hl("DiffDelete", { bg = "#120f16" })
hl("DiffText", { bg = "#2a2233" })

-- Treesitter links
hl("@comment", { link = "Comment" })
hl("@string", { link = "String" })
hl("@character", { link = "Character" })
hl("@number", { link = "Number" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { link = "Constant" })
hl("@variable", { link = "Identifier" })
hl("@parameter", { fg = p.fg })
hl("@field", { fg = p.fg })
hl("@property", { fg = p.fg })
hl("@function", { link = "Function" })
hl("@function.call", { fg = p.accent })
hl("@keyword", { link = "Keyword" })
hl("@keyword.return", { fg = p.accent, italic = true })
hl("@type", { link = "Type" })
hl("@type.builtin", { fg = p.accent_soft, italic = true })
hl("@operator", { link = "Operator" })
hl("@punctuation", { fg = p.fg_muted })
hl("@punctuation.delimiter", { fg = p.fg_muted })
hl("@punctuation.bracket", { fg = p.fg_muted })

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "chromozome",
    callback = function()
        local set = vim.api.nvim_set_hl

        -- Telescope
        set(0, "TelescopeNormal", { fg = p.fg, bg = p.bg_alt })
        set(0, "TelescopeBorder", { fg = p.border, bg = p.bg_alt })
        set(0, "TelescopePromptNormal", { fg = p.fg, bg = p.bg_alt })
        set(0, "TelescopePromptBorder", { fg = p.accent, bg = p.bg_alt })
        set(0, "TelescopeSelection", { bg = "#22222b", bold = true })

        -- Neo-tree
        set(0, "NeoTreeNormal", { fg = p.fg, bg = p.bg })
        set(0, "NeoTreeNormalNC", { fg = p.fg, bg = p.bg })
        set(0, "NeoTreeCursorLine", { bg = "#16161d" })
        set(0, "NeoTreeDirectoryName", { fg = p.accent })
        set(0, "NeoTreeRootName", { fg = p.accent, bold = true })

        -- Cmp
        set(0, "CmpItemAbbr", { fg = p.fg })
        set(0, "CmpItemAbbrMatch", { fg = p.accent, bold = true })
        set(0, "CmpItemKind", { fg = p.fg_muted })

        -- WhichKey
        set(0, "WhichKey", { fg = p.accent, bold = true })
        set(0, "WhichKeyDesc", { fg = p.fg })
        set(0, "WhichKeySeparator", { fg = p.fg_muted })
    end,
})
