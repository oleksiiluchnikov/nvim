return {
    {
        -- [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
        -- Rainbow delimiters for neovim
        -- FIXME: This plugin breaks my tree-sitter highlighting
        -----------------------------------------------------------------------
        'HiPhish/rainbow-delimiters.nvim',
        url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git',
        cond = false,
        config = function()
            local rainbow_delimiters = require('rainbow-delimiters')
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                priority = {
                    [''] = 110,
                    lua = 210,
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end,
    },
}
