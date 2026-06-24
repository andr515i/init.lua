local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

-- Helper: find the nearest class name above the cursor
local function get_class_name()
    local line_count = vim.api.nvim_buf_line_count(0)
    local class_name = "MyClass"

    for line = 1, line_count do
        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
        local match = text:match("class%s+([%w_]+)")
        if match then
            class_name = match
        end
    end

    return class_name
end
return {
    s("csfile", {
        t("namespace "),

        -- dynamic namespace: parent folder name, but still editable
        d(1, function(_, _)
            -- folder that contains the current file
            local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            if dir == "" then
                dir = "MyNamespace" -- fallback
            end
            -- make it an insert node so it's highlighted/jumpable
            return sn(nil, { i(1, dir) })
        end, {}),

        t({ "", "{", "\tinternal class " }),
        i(2, "MyClass"),
        t({ "", "\t{", "\t\t" }),
        i(3, "// TODO: implementation"),
        t({ "", "\t}", "}" }),
    }),

    s("cc", {
        t({ "internal class " }),
        i(1, "MyClass"),
        t({ "", "{", "\t" }),
        i(2, "// TODO: implementation"),
        t({ "", "}" }),
    }),

    s("ii", {
        t({ "internal interface " }),
        i(1, "MyInterface"),
        t({ "", "{", "\t" }),
        i(2, "// TODO: implementation"),
        t({ "", "}" }),
    }),
    s("struct", {
        t({ "internal struct " }),
        i(1, "MyStruct"),
        t({ "", "{", "\t" }),
        i(2, "// TODO: implementation"),
        t({ "", "}" }),
    }),

    s("prop", {
        t("internal "),
        i(1, "string"),
        t(" "),
        i(2, "Name"),
        t(" { get; set; }"),
        t({ "", "" }),
    }),

    s("ctor", {
        d(1, function()
            local class = get_class_name()
            return sn(nil, t("internal " .. class .. "("))
        end),
        i(2, "/* paremeters */"),
        t(")"),
        t({ "", "{" }),
        t({ "", "   " }),
        i(3, "// TODO: initialize fields"),
        t({ "", "}" }),
    }),

    s("cw", {
        t('Console.WriteLine("'),
        i(1, "text"),
        t('");'),
    }),

    s("met", {
        i(1, "internal"),
        t(" "),
        i(2, "void"),
        t(" "),
        i(3, "MethName"),
        t("( "),
        i(4, "/* Params */"),
        t(" )"),
        t({ "", "{" }),
        t({ "", "" }),
        i(5, "\t// TODO: Implement Method"),
        t({ "", "}" }),
    }),
}
