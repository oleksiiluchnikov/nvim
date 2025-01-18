return {
    {
        -- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)
        -- Advanced quickfix window
        -----------------------------------------------------------------------
        'kevinhwang91/nvim-bqf',
        event = 'LspAttach',
        opts = {
            magic_window = true,
            auto_enable = true,
            auto_resize_height = true, -- highly recommended enable
            preview = {
                buf_label = true,
                win_height = 12,
                show_scroll_bar = false,
                wrap = false,
                winblend = 0,
                auto_preview = true,
                win_vheight = 12,
                delay_syntax = 80,
                border = 'rounded',
                show_title = false,
                ---@diagnostic disable-next-line: unused-local
                should_preview_cb = function(bufnr, qwinid)
                    local ret = true
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    local fsize = vim.fn.getfsize(bufname)
                    if fsize > 100 * 1024 then
                        -- skip file size greater than 100k
                        ret = false
                    elseif string.match(bufname, '^fugitive://') then
                        -- skip fugitive buffer
                        ret = false
                    end
                    return ret
                end,
            },
            -- make `drop` and `tab drop` to become preferred
            func_map = {
                drop = 'o',
                openc = 'O',
                split = '<C-s>',
                tabdrop = '<C-t>',
                -- set to empty string to disable
                tabc = '',
                ptogglemode = 'z,',
            },
            filter = {
                fzf = {
                    action_for = {
                        ['ctrl-s'] = 'split',
                        ['ctrl-t'] = 'tab drop',
                    },
                    extra_opts = {
                        '--bind',
                        'ctrl-o:toggle-all',
                        '--prompt',
                        '> ',
                    },
                },
            },
        },
        config = function()
            vim.api.nvim_set_hl(0, 'BqfPreviewRange', { link = 'Search' })
            vim.api.nvim_set_hl(
                0,
                'BqfPreviewBorder',
                { fg = require('catppuccin.palettes').get_palette('latte').red }
            )
            vim.api.nvim_set_hl(
                0,
                'BqfPreviewTitle',
                { fg = require('catppuccin.palettes').get_palette('latte').red }
            )
            vim.api.nvim_set_hl(
                0,
                'BqfPreviewThumb',
                { fg = require('catppuccin.palettes').get_palette('latte').red }
            )
        end,
    },
}
