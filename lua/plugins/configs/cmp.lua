local cmp = require("cmp")

local cmp_kinds = {
    Text = "  ",
    Method = "  ",
    Function = "() ",
    Constructor = "  ",
    Field = "  ",
    Variable = "  ",
    Class = "  ",
    Interface = "  ",
    Module = "  ",
    Property = "  ",
    Unit = "  ",
    Value = "  ",
    Enum = "  ",
    Keyword = "  ",
    Snippet = "",
    Color = "  ",
    File = "  ",
    Reference = "  ",
    Folder = "  ",
    EnumMember = "  ",
    Constant = "  ",
    Struct = "  ",
    Event = "  ",
    Operator = "  ",
    TypeParameter = "  ",
}

local function border(hl_name)
    return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
    }
end

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
luasnip.config.setup({})


cmp.setup({
    formatting = {
        format = require("lspkind").cmp_format({
            -- mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
	    vim_item = function (_, vim_item)
		vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
		return vim_item
	    end,
        }),
	expandable_indicator = true,
	fields = { 'abbr', 'kind', 'menu' },
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },

    },

    window = {
        completion = {
            border = border("rounded"),
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:Pmenu",
            scrollbar = false,
        },
    },

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- if cmp.visible() then
            -- cmp.select_next_item()
            -- else
            if require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                -- cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    }),
})

local M = {}

M.luasnip = function(opts)
    -- vscode format
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

    -- snipmate format
    require("luasnip.loaders.from_snipmate").load()
    require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

    -- lua format
    require("luasnip.loaders.from_lua").load()
    require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            if
                require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                and not require("luasnip").session.jump_active
            then
                require("luasnip").unlink_current()
            end
        end,
    })
end
return M

