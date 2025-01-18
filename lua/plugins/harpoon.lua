return {
    {
        -- [harpoon.nvim](https://github.com/ThePrimeagen/harpoon)
        -- Navigating to files/buffers blazingly fast
        -----------------------------------------------------------------------
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        --- @type HarpoonPartialConfig
        opts = {
            menu = {
                width = vim.api.nvim_win_get_width(0) - 10,
            },
            settings = {
                save_on_toggle = true,
                save_on_change = true,
                enter_on_sendcmd = false,
                tmux_autoclose_windows = false,
                excluded_filetypes = {
                    'harpoon',
                },
                mark_branch = false,
                tabline = false,
                tabline_prefix = '   ',
                tabline_suffix = '   ',
            },
        },
        keys = {
            {
                '<leader>a',
                function()
                    require('harpoon'):list():add()
                    vim.notify(
                        'Added: ' .. tostring(vim.fn.expand('%')),
                        vim.log.levels.INFO,
                        {
                            title = 'Harpoon',
                            timeout = 100,
                        }
                    )
                end,
                { silent = true, desc = 'add file to harpoon' },
            },
            {
                '<leader>j',
                function()
                    require('harpoon.ui').toggle_quick_menu(
                        require('harpoon'):list()
                    )
                end,
                { silent = true, desc = 'toggle harpoon menu' },
            },
            {
                '<leader>t',
                function()
                    require('harpoon.term').gotoTerminal()
                end,
                { silent = true, desc = 'go to terminal' },
            },
            {
                '<C-e>',
                function()
                    require('harpoon'):list():select(1)
                end,
                {
                    silent = true,
                    desc = 'navigate to harpoon file 1',
                },
            },
            {
                '<C-a>',
                function()
                    require('harpoon'):list():select(2)
                end,
                {
                    silent = true,
                    desc = 'navigate to harpoon file 2',
                },
            },
            {
                '<C-h>',
                function()
                    require('harpoon'):list():select(3)
                end,
                {
                    silent = true,
                    desc = 'navigate to harpoon file 3',
                },
            },
            {
                '<C-i>',
                function()
                    require('harpoon'):list():select(4)
                end,
                {
                    silent = true,
                    desc = 'navigate to harpoon file 4',
                },
            },
        },
        event = 'BufEnter',
    },
}
