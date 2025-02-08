return {
    -- add blink.compat
    {
        'saghen/blink.compat',
        version = '*',
        lazy = true,
        opts = {},
    },
    {
        'giuxtaposition/blink-cmp-copilot',
    },
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '*',
        opts = {
            completion = {
                keyword = {
                    range = 'full',
                },
                list = {
                    max_items = 99999,
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
                menu = {
                    enabled = true,
                    min_width = 15,
                    max_height = vim.o.lines - 5,
                    border = 'none',
                    winblend = 0,
                    winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
                    -- Keep the cursor X lines away from the top/bottom of the window
                    scrolloff = 2,
                    -- Note that the gutter will be disabled when border ~= 'none'
                    scrollbar = true,
                    -- Which directions to show the window,
                    -- falling back to the next direction when there's not enough space
                    direction_priority = { 's', 'n' },

                    -- Whether to automatically show the window when new completion items are available
                    auto_show = true,

                    -- Screen coordinates of the command line
                    cmdline_position = function()
                        if vim.g.ui_cmdline_pos ~= nil then
                            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                            return { pos[1] - 1, pos[2] }
                        end
                        local height = (vim.o.cmdheight == 0) and 1
                            or vim.o.cmdheight
                        return { vim.o.lines - height, 0 }
                    end,
                    draw = {
                        -- Aligns the keyword you've typed to a component in the menu
                        align_to = 'cursor', -- or 'none' to disable, or 'cursor' to align to the cursor
                        -- Left and right padding, optionally { left, right } for different padding on each side
                        padding = 0,
                        -- Gap between columns
                        gap = 1,
                        -- Use treesitter to highlight the label text for the given list of sources
                        treesitter = { 'lsp' },
                        -- treesitter = { 'lsp' }

                        -- Components to render, grouped by column
                        columns = {
                            { 'label', 'label_description', gap = 1 },
                            { 'kind_icon', 'kind' },
                            { 'source_name' },
                        },
                        -- Definitions for possible components to render. Each defines:
                        --   ellipsis: whether to add an ellipsis when truncating the text
                        --   width: control the min, max and fill behavior of the component
                        --   text function: will be called for each item
                        --   highlight function: will be called only when the line appears on screen
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    return ctx.kind_icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    return require(
                                        'blink.cmp.completion.windows.render.tailwind'
                                    ).get_hl(
                                        ctx
                                    ) or 'BlinkCmpKind' .. ctx.kind
                                end,
                            },

                            kind = {
                                ellipsis = false,
                                width = { fill = true },
                                text = function(ctx)
                                    return ctx.kind
                                end,
                                highlight = function(ctx)
                                    return require(
                                        'blink.cmp.completion.windows.render.tailwind'
                                    ).get_hl(
                                        ctx
                                    ) or 'BlinkCmpKind' .. ctx.kind
                                end,
                            },

                            label = {
                                width = {
                                    fill = true,
                                    max = vim.o.columns * 0.75,
                                },
                                text = function(ctx)
                                    return ctx.label .. ctx.label_detail
                                end,
                                highlight = function(ctx)
                                    -- label and label details
                                    local highlights = {
                                        {
                                            0,
                                            #ctx.label,
                                            group = ctx.deprecated
                                                    and 'BlinkCmpLabelDeprecated'
                                                or 'BlinkCmpLabel',
                                        },
                                    }
                                    if ctx.label_detail then
                                        table.insert(highlights, {
                                            #ctx.label,
                                            #ctx.label + #ctx.label_detail,
                                            group = 'BlinkCmpLabelDetail',
                                        })
                                    end

                                    -- characters matched on the label by the fuzzy matcher
                                    for _, idx in
                                        ipairs(ctx.label_matched_indices)
                                    do
                                        table.insert(highlights, {
                                            idx,
                                            idx + 1,
                                            group = 'BlinkCmpLabelMatch',
                                        })
                                    end

                                    return highlights
                                end,
                            },

                            label_description = {
                                width = { max = vim.o.columns * 0.75 },
                                text = function(ctx)
                                    return ctx.label_description
                                end,
                                highlight = 'BlinkCmpLabelDescription',
                            },

                            source_name = {
                                width = { max = vim.o.columns * 0.75 },
                                text = function(ctx)
                                    return ctx.source_name
                                end,
                                highlight = 'BlinkCmpSource',
                            },
                        },
                    },
                },
                documentation = {
                    -- Controls whether the documentation window will automatically show when selecting a completion item
                    auto_show = true,
                    -- Delay before showing the documentation window
                    auto_show_delay_ms = 1,
                    -- Delay before updating the documentation window when selecting a new item,
                    -- while an existing item is still visible
                    update_delay_ms = 1,
                    -- Whether to use treesitter highlighting, disable if you run into performance issues
                    treesitter_highlighting = true,
                    window = {
                        min_width = 10,
                        max_width = vim.o.columns * 0.75,
                        max_height = vim.o.lines * 0.6,
                        border = 'padded',
                        winblend = 0,
                        winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
                        -- Note that the gutter will be disabled when border ~= 'none'
                        scrollbar = true,
                        -- Which directions to show the documentation window,
                        -- for each of the possible menu window directions,
                        -- falling back to the next direction when there's not enough space
                        direction_priority = {
                            menu_north = { 'e', 'w', 'n', 's' },
                            menu_south = { 'e', 'w', 's', 'n' },
                        },
                    },
                },
            },
            keymap = {
                preset = 'default',
                ['<C-y>'] = {
                    function(fallback)
                        local has_words_before = function()
                            local line, col =
                                unpack(vim.api.nvim_win_get_cursor(0))
                            return col ~= 0
                                and vim.api
                                        .nvim_buf_get_lines(0, line - 1, line, true)[1]
                                        :sub(col, col)
                                        :match('%s')
                                    == nil
                        end

                        local function replace_termcodes(str)
                            return vim.api.nvim_replace_termcodes(
                                str,
                                true,
                                true,
                                true
                            )
                        end

                        local function check_backspace()
                            local col = vim.fn.col('.') - 1
                            return col == 0
                                or vim.fn.getline('.'):sub(col, col):match('%s')
                        end

                        local cmp = require('blink.cmp')
                        local copilot_accept = vim.fn['copilot#Accept']
                        local copilot_keys = ''
                        if copilot_accept then
                            local ok, copilot_keys_ = pcall(copilot_accept)
                            if ok then
                                copilot_keys = copilot_keys_
                            end
                        end
                        local has_avante, avante_api =
                            pcall(require, 'avante.api')
                        local avante_suggestion = nil
                        if has_avante then
                            avante_suggestion = avante_api.get_suggestion()
                        end
                        local has_supermaven, supermaven_suggestion =
                            pcall(require, 'supermaven-nvim.completion_preview')
                        local has_copilot_lua, copilot_lua_suggestion =
                            pcall(require, 'copilot.suggestion')

                        if copilot_keys ~= '' then
                            vim.api.nvim_feedkeys(copilot_keys, 'i', true)
                        elseif
                            avante_suggestion and avante_suggestion:is_visible()
                        then
                            avante_suggestion:accept()
                        elseif
                            has_supermaven
                            and supermaven_suggestion.has_suggestion()
                        then
                            supermaven_suggestion.on_accept_suggestion()
                        elseif
                            has_copilot_lua
                            and copilot_lua_suggestion.is_visible()
                        then
                            copilot_lua_suggestion.accept_line()
                        elseif cmp.is_visible() then
                            cmp.accept()
                        elseif check_backspace() then
                            vim.fn.feedkeys(replace_termcodes('<Tab>'), 'n')
                        else
                            return true
                        end
                    end,
                },
                ['<C-l>'] = {
                    function(fallback)
                        local cmp = require('blink.cmp')
                        local copiolt_suggestion = require('copilot.suggestion')
                        if copiolt_suggestion.is_visible() then
                            copiolt_suggestion.accept_line()
                            return
                        end
                    end,
                    'accept',
                },
                ['<C-j>'] = {
                    function(fallback)
                        local cmp = require('blink.cmp')
                        local copiolt_suggestion = require('copilot.suggestion')
                        if copiolt_suggestion.is_visible() then
                            copiolt_suggestion.accept()
                            return
                        end
                    end,
                    'accept',
                },
                ['up'] = {
                    function(fallback)
                        local cmp = require('blink.cmp')
                        if vim.fn.mode() == 'c' then
                            fallback()
                        elseif cmp.is_visible() then
                            cmp.select_prev()
                        else
                            require('config.utils').jump_to_next_line_with_same_indent(
                                false,
                                { 'end', '-' }
                            )
                            return true
                        end
                    end,
                },
                ['down'] = {
                    function(fallback)
                        local cmp = require('blink.cmp')
                        if vim.fn.mode() == 'c' then
                            fallback()
                        elseif cmp.is_visible() then
                            cmp.select_next()
                        else
                            require('config.utils').jump_to_next_line_with_same_indent(
                                true,
                                { 'end', '-' }
                            )
                            return true
                        end
                    end,
                },
                documentation = { auto_show = true, auto_show_delay_ms = 0 },
                ghost_text = { enabled = false },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },
            sources = {
                default = {
                    'path',
                    'cody',
                    'copilot',
                    'vault_tag',
                    'vault_date',
                    'vault_properties',
                    'vault_property_values',
                    'lazydev',
                    'lsp',
                    'snippets',
                    'buffer',
                },
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                    copilot = {
                        name = 'copilot',
                        module = 'blink-cmp-copilot',
                        score_offset = 100,
                        async = true,
                    },
                    cody = {
                        name = 'cody',
                        module = 'blink.compat.source',
                        opts = {},
                    },
                    vault_tag = {
                        name = 'vault_tag',
                        module = 'blink.compat.source',
                        opts = {},
                    },
                    vault_date = {
                        name = 'vault_date',
                        module = 'blink.compat.source',
                        opts = {},
                    },
                    vault_properties = {
                        name = 'vault_properties',
                        module = 'blink.compat.source',
                        opts = {},
                    },
                    vault_property_values = {
                        name = 'vault_property_values',
                        module = 'blink.compat.source',
                        opts = {},
                    },
                },
            },
            signature = { enabled = false },
        },
        opts_extend = { 'sources.default' },
    },
}
