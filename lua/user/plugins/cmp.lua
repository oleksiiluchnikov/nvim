--
-- Complitions settings (nvim-cmp)
--
-- @module user.configs.cmp

------------------------------------------------------------------------------
local cmp = require('cmp')
------------------------------------------------------------------------------
local style_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

------------------------------------------------------------------------------
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    style = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        scrollbar = "║",
        border = style_border,
    },
    formatting = {
        fields = { "abbr", "menu" , "kind" },
        format = function(entry, vim_item)
            vim_item.menu_hl_group = "CmpItemKind" .. vim_item.kind
            vim_item.menu = vim_item.kind
            vim_item.abbr = vim_item.abbr:sub(1, 50) -- truncate long items to 50 chars
            return vim_item
        end
    },
    window = {
        completion = {
            border = style_border,
            scrollbar = "║",
            winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:CmpSelection,Search:None',
            autocomplete = {
                require("cmp.types").cmp.TriggerEvent.InsertEnter,
                require("cmp.types").cmp.TriggerEvent.TextChanged,
            },
        },
        documentation = {
            border = style_border,
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            scrollbar = "║",
        },
    },
    -- show first matching item as ghost text
    ghost_text = {
        enabled = false,
        prefix = " ",
        suffix = " ",
    },
    experimental = {
        native_menu = false,
        ghost_text = false,
    },
    sources = {
        { name = "path",     group_index = 2 },
        { name = "nvim_lsp", group_index = 2, keyword_length = 2 },
        { name = 'nvim_lsp_signature_help'},
        { name = 'nvim_lua', keyword_length = 2 },
        { name = 'buffer', keyword_length = 2 },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'neorg',    group_index = 2 },
    },
    sorting = {
        --keep priority weight at 2 for much closer matches to appear above copilot
        --set to 1 to make copilot always appear on top
        priority_weight = 1,
        comparators = {
            -- order matters here
            cmp.config.compare.exact,
            cmp.config.compare.offset,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    preselect = cmp.PreselectMode.Item,
})

--set max height of items
vim.cmd([[ set pumheight=10 ]])

------------------------------------------------------------------------------

--set highlights
local highlights = {
    -- type highlights
    CmpItemKindText = { fg = "LightGrey" },
    CmpItemKindFunction = { fg = "#C586C0" },
    CmpItemKindClass = { fg = "Orange" },
    CmpItemKindKeyword = { fg = "#f90c71" },
    CmpItemKindSnippet = { fg = "#565c64" },
    CmpItemKindConstructor = { fg = "#ae43f0" },
    CmpItemKindVariable = { fg = "#9CDCFE", bg = "NONE" },
    CmpItemKindInterface = { fg = "#f90c71", bg = "NONE" },
    CmpItemKindFolder = { fg = "#2986cc" },
    CmpItemKindReference = { fg = "#922b21" },
    CmpItemKindMethod = { fg = "#C586C0" },
    CmpItemKindCopilot = { fg = "#6CC644" },
    -- CmpItemMenu = { fg = "#C586C0", bg = "#C586C0" },
    CmpItemAbbr = { fg = "#565c64", bg = "NONE" },
    CmpItemAbbrMatch = { fg = "#569CD6", bg = "NONE" },
    CmpItemAbbrMatchFuzzy = { fg = "#569CD6", bg = "NONE" },
    CmpMenuBorder = { fg = "#263341" },
    CmpMenu = { bg = "#10171f" },
    CmpSelection = { bg = "#263341" },
}

-- set highlights for all groups in highlights table above
for group, hl in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, hl)
end

------------------------------------------------------------------------------

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})
-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline('?', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline('!', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup()
