local cmp = require("cmp")
-- local border = require("user.styles").borders.solid

---@class cmp.ConfigSchema
local opts = {}

opts.snippet = {
    expand = function(args)
        require("luasnip").lsp_expand(args.body)
    end,
}

opts.style = {
    scrollbar = "║",
    border = border,
}

opts.formatting = {
    expandable_indicator = false,
    fields = { "abbr", "kind", "menu" },
    format = function(entry, item)
        item.menu_hl_group = "CmpItemKind" .. item.kind
        local menu_icon = {
            cody = "[Cody]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[Lua]",
            buffer = "[Buf]",
            luasnip = "[Snip]",
            path = "[Path]",
            neorg = "[Neorg]",
            vault_tag = "[Tag]",
            vault_date = "[Date]",
        }
        item.menu = menu_icon[entry.source.name]
        if item.kind == "Text" then
            item.kind = ""
        end
        return item
    end,
}
opts.window = {
    completion = {
        border = { "", "", "", "│", "╯", "─", "╰", "│" },
        zindex = 50,
        col_offset = 0,
        side_padding = 0,
        scrollbar = true,
        winhighlight = "Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:CmpSelection,Search:None",
        autocomplete = {
            require("cmp.types").cmp.TriggerEvent.InsertEnter,
            require("cmp.types").cmp.TriggerEvent.TextChanged,
        },
    },
    documentation = cmp.config.window.bordered({
        winhighlight = "Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:CmpSelection,Search:None",
    }),
}
opts.ghost_text = {
    enabled = false,
}
opts.experimental = {
    ghost_text = false,
}
opts.view = {
    entries = { name = "custom", selection_order = "near_cursor" },
    docs = {
        auto_open = true,
    },
}
opts.sources = {
    { name = "path" },
    { name = "cody" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "neorg" },
    { name = "vault_tag" },
    { name = "vault_date" },
}
opts.sorting = {
    priority_weight = 2,
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
}
opts.preselect = cmp.PreselectMode.Item

cmp.setup(opts)
cmp.setup.filetype({ "TelescopePrompt" }, opts)

--set max height of items
vim.cmd([[ set pumheight=20 ]])
vim.api.nvim_set_hl(0, "CmpItemKindCody", { fg = "Red" })

------------------------------------------------------------------------------

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})
-- `/` cmdline setup.
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})
cmp.setup.cmdline("?", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})
cmp.setup.cmdline("!", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})
local copilot_suggestion = require("copilot.suggestion")

-- local luasnip = require('luasnip')
vim.keymap.set("i", "<C-y>", function(fallback)
    if copilot_suggestion.is_visible() then
        copilot_suggestion.accept_word()
    elseif cmp.visible() then
        cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = select,
        })()
        -- elseif luasnip.expandable() then
        --   luasnip.expand()
    else
        fallback()
    end
end, {
    silent = true,
    desc = "confirm completion with C-y(es)",
})

-- Accept line
vim.keymap.set("i", "<C-c>", function()
    if copilot_suggestion.is_visible() then
        copilot_suggestion.accept_line()
    end
end, {
    silent = true,
    desc = "copilot: accept line",
})

-- Accept whole copilot suggestion
vim.keymap.set("i", "<C-j>", function()
    local copilot = copilot_suggestion
    if copilot.is_visible() then
        copilot.accept()
    end
end, {
    silent = true,
    desc = "copilot: accept whole suggestion",
})

-- Confirm Complition with C-y(es) in command mode
vim.keymap.set("c", "<C-y>", function()
    if cmp.visible() then
        cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = select,
        })()
    end
end, {
    silent = true,
    desc = "confirm completion with C-y(es)",
})

vim.keymap.set("!", "<C-y>", function()
    if cmp.visible() then
        cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = select,
        })()
    end
end, {
    silent = true,
    desc = "confirm completion with C-y(es)",
})

-- Select Next Item with C-n(ext)
vim.keymap.set("i", "<C-n>", function(fallback)
    if copilot_suggestion.is_visible() then
        copilot_suggestion.next()
    elseif cmp.visible() then
        cmp.select_next_item()
        -- elseif luasnip.expandable() then
        --   luasnip.jump(1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = "select next item with C-n(ext)",
})

vim.keymap.set("c", "<C-n>", function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
        -- elseif luasnip.expandable() then
        --   luasnip.jump(1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = "select next item with C-n(ext)",
})

vim.keymap.set("!", "<C-n>", function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
        -- elseif luasnip.expandable() then
        --   luasnip.jump(1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = "select next item with C-n(ext)",
})

-- Select Previous Item with C-p(revious)
vim.keymap.set("i", "<C-p>", function(fallback)
    if copilot_suggestion.is_visible() then
        copilot_suggestion.prev()
    elseif cmp.visible() then
        cmp.select_prev_item()
        -- elseif luasnip.jumpable(-1) then
        --   luasnip.jump(-1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = "select previous item with C-p(revious)",
})

vim.keymap.set("!", "<C-p>", function(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
        -- elseif luasnip.expandable() then
        --   luasnip.jump(-1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = "select next item with C-n(ext)",
})

-- Scroll documentation / diagnostic preview C-u(p)
vim.keymap.set("i", "<C-u>", function(fallback)
    if cmp.visible() then
        cmp.scroll_docs(-4)
    else
        fallback()
    end
end, {
    silent = true,
    desc = "scroll documentation / diagnostic preview up in insert mode",
})

-- Scroll documentation / diagnostic preview C-d(own)
vim.keymap.set("i", "<C-d>", function(fallback)
    if cmp.visible() then
        cmp.scroll_docs(4)
    else
        fallback()
    end
end, {
    silent = true,
    desc = "scroll documentation / diagnostic preview down in insert mode",
})
