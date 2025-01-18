return {
    -- add blink.compat
    {
        'saghen/blink.compat',
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = '*',
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
    },
    {
        'giuxtaposition/blink-cmp-copilot',
    },

    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        version = '*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
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
                        -- local copilot_suggestion = require('copilot.suggestion')
                        local cmp = require('blink.cmp')
                        -- local luasnip = require('luasnip')
                        -- local has_avante, avante_api = pcall(require, 'avante.api')
                        -- -- local supermaven_suggestion =
                        -- --     require('supermaven-nvim.completion_preview')
                        -- -- if supermaven_suggestion.has_suggestion() then
                        -- --     supermaven_suggestion.on_accept_suggestion_word()
                        -- if copilot_suggestion.is_visible() then
                        --     copilot_suggestion.accept_word()
                        -- elseif cmp.visible() then
                        --     cmp.mapping.confirm({
                        --         behavior = cmp.ConfirmBehavior.Replace,
                        --         select = select,
                        --     })()
                        -- else
                        --     return
                        -- end
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
                        -- if options.tab_complete_copilot_first then
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
                            -- cmp.select_next_item()
                            -- cmp.mapping.confirm({
                            --     behavior = cmp.ConfirmBehavior.Replace,
                            --     select = select,
                            -- })()
                            cmp.accept()
                        -- elseif luasnip.expand_or_jumpable() then
                        --     vim.fn.feedkeys(
                        --         replace_termcodes(
                        --             '<Plug>luasnip-expand-or-jump'
                        --         ),
                        --         ''
                        --     )
                        elseif check_backspace() then
                            vim.fn.feedkeys(replace_termcodes('<Tab>'), 'n')
                        else
                            return true
                        end
                        -- else
                        --     if cmp.visible() then
                        --         cmp.select_next_item()
                        --     elseif copilot_keys ~= '' then
                        --         vim.api.nvim_feedkeys(copilot_keys, 'i', true)
                        --     elseif luasnip.expand_or_jumpable() then
                        --         vim.fn.feedkeys(
                        --             replace_termcodes(
                        --                 '<Plug>luasnip-expand-or-jump'
                        --             ),
                        --             ''
                        --         )
                        --     elseif check_backspace() then
                        --         vim.fn.feedkeys(replace_termcodes('<Tab>'), 'n')
                        --     else
                        --         return
                        --     end
                        -- end
                    end,
                    -- 'accept',
                },
                ['C-l'] = {
                    function(fallback)
                        -- accept line
                        local cmp = require('blink.cmp')
                        local copiolt_suggestion = require('copilot.suggestion')
                        if copiolt_suggestion.is_visible() then
                            copiolt_suggestion.accept_line()
                            -- elseif cmp.is_visible() then
                            --     cmp.accept()
                            -- else
                            --     return true
                            return
                        end
                    end,
                    'accept',
                },
                ['<C-j>'] = {
                    function(fallback) -- accept all
                        local cmp = require('blink.cmp')
                        local copiolt_suggestion = require('copilot.suggestion')
                        if copiolt_suggestion.is_visible() then
                            copiolt_suggestion.accept()
                            -- elseif cmp.is_visible() then
                            --     cmp.accept()
                            -- else
                            --     return true
                            return
                        end
                    end,
                    'accept',
                },
                ['up'] = {
                    function(fallback) -- accept all
                        local cmp = require('blink.cmp')
                        if cmp.is_visible() then
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
                    function(fallback) -- accept all
                        local cmp = require('blink.cmp')

                        if cmp.is_visible() then
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
                completion = {
                    -- Maximum number of items to display
                    max_items = 200,
                    menu = {
                        enabled = true,
                        min_width = 60,
                        max_height = 200,
                        border = 'rounded',
                        auto_show = true,

                        draw = {
                            align_to = 'cursor',
                            columns = {
                                { 'label', 'label_description', gap = 1 },
                                { 'kind_icon', 'kind' },
                            },
                            treesitter = true,
                            -- components = {
                            --     kind_icon = {
                            --         ellipsis = false,
                            --         text = function(ctx)
                            --             return ctx.kind_icon .. ctx.icon_gap
                            --         end,
                            --         highlight = function(ctx)
                            --             return require(
                            --                 'blink.cmp.completion.windows.render.tailwind'
                            --             ).get_hl(
                            --                 ctx
                            --             ) or 'BlinkCmpKind' .. ctx.kind
                            --         end,
                            --     },
                            --
                            --     kind = {
                            --         ellipsis = false,
                            --         width = { fill = true },
                            --         text = function(ctx)
                            --             return ctx.kind
                            --         end,
                            --         highlight = function(ctx)
                            --             return require(
                            --                 'blink.cmp.completion.windows.render.tailwind'
                            --             ).get_hl(
                            --                 ctx
                            --             ) or 'BlinkCmpKind' .. ctx.kind
                            --         end,
                            --     },
                            --
                            --     label = {
                            --         width = { fill = true, max = 60 },
                            --         text = function(ctx)
                            --             return ctx.label .. ctx.label_detail
                            --         end,
                            --         highlight = function(ctx)
                            --             -- label and label details
                            --             local highlights = {
                            --                 {
                            --                     0,
                            --                     #ctx.label,
                            --                     group = ctx.deprecated
                            --                             and 'BlinkCmpLabelDeprecated'
                            --                         or 'BlinkCmpLabel',
                            --                 },
                            --             }
                            --             if ctx.label_detail then
                            --                 table.insert(highlights, {
                            --                     #ctx.label,
                            --                     #ctx.label + #ctx.label_detail,
                            --                     group = 'BlinkCmpLabelDetail',
                            --                 })
                            --             end
                            --
                            --             -- characters matched on the label by the fuzzy matcher
                            --             for _, idx in
                            --                 ipairs(ctx.label_matched_indices)
                            --             do
                            --                 table.insert(highlights, {
                            --                     idx,
                            --                     idx + 1,
                            --                     group = 'BlinkCmpLabelMatch',
                            --                 })
                            --             end
                            --
                            --             return highlights
                            --         end,
                            --     },
                            --
                            --     label_description = {
                            --         width = { max = 30 },
                            --         text = function(ctx)
                            --             return ctx.label_description
                            --         end,
                            --         highlight = 'BlinkCmpLabelDescription',
                            --     },
                            --
                            --     source_name = {
                            --         width = { max = 30 },
                            --         text = function(ctx)
                            --             return ctx.source_name
                            --         end,
                            --         highlight = 'BlinkCmpSource',
                            --     },
                            -- },
                        },
                    },
                    -- Show documentation when selecting a completion item
                    documentation = { auto_show = true, auto_show_delay_ms = 5 },

                    -- Display a preview of the selected item on the current line
                    ghost_text = { enabled = false },
                },

                appearance = {
                    -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                    -- Useful for when your theme doesn't support blink.cmp
                    -- Will be removed in a future release
                    use_nvim_cmp_as_default = true,
                    -- nvim-cmp style menu
                    -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = 'mono',
                },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
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
                        -- create provider
                        -- digraphs = {
                        --     name = 'digraphs', -- IMPORTANT: use the same name as you would for nvim-cmp
                        --     module = 'blink.compat.source',
                        --
                        --     -- all blink.cmp source config options work as normal:
                        --     score_offset = -3,
                        --
                        --     -- this table is passed directly to the proxied completion source
                        --     -- as the `option` field in nvim-cmp's source config
                        --     --
                        --     -- this is NOT the same as the opts in a plugin's lazy.nvim spec
                        --     opts = {
                        --         -- this is an option from cmp-digraphs
                        --         cache_digraphs_on_start = true,
                        --     },
                        -- },
                        lazydev = {
                            name = 'LazyDev',
                            module = 'lazydev.integrations.blink',
                            -- make lazydev completions top priority (see `:h blink.cmp`)
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
                            opts = {
                                -- this is an option from cmp-cody
                                -- tab_complete_cody_first = true,
                            },
                        },
                        vault_tag = {
                            name = 'vault_tag',
                            module = 'blink.compat.source',
                            opts = {
                                -- this is an option from cmp-vault
                                -- tab_complete_vault_tag_first = true,
                            },
                        },
                        vault_date = {
                            name = 'vault_date',
                            module = 'blink.compat.source',
                            opts = {
                                -- this is an option from cmp-vault
                                -- tab_complete_vault_date_first = true,
                            },
                        },
                        vault_properties = {
                            name = 'vault_properties',
                            module = 'blink.compat.source',
                            opts = {
                                -- this is an option from cmp-vault
                                -- tab_complete_vault_properties_first = true, he
                            },
                        },
                        vault_property_values = {
                            name = 'vault_property_values',
                            module = 'blink.compat.source',
                            opts = {
                                -- this is an option from cmp-vault
                                -- tab_complete_vault_property_values_first = true,
                            },
                        },
                    },
                },
            },
            signature = { enabled = false },
        },
        opts_extend = { 'sources.default' },
    },
}
