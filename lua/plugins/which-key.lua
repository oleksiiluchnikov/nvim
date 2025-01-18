-- https://github.com/folke/which-key.nvim
return {

    {
        'folke/which-key.nvim',
        init = function()
            vim.g.timeout = true
            vim.o.timeoutlen = 50
            vim.o.ttimeoutlen = 50
        end,
        opts = {
            spec = {
                { '<BS>', desc = 'Decrement Selection', mode = 'x' },
                {
                    '<c-space>',
                    desc = 'Increment Selection',
                    mode = { 'x', 'n' },
                },
            },
        },
    },
}
