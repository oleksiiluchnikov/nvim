return {
    {
        -- [ts-comments.nvim](https://github.com/JoosepAlviste/ts-comments.nvim)
        -- allows you to quickly add, toggle, and remove comments in TypeScript, JavaScript, and Java files.
        ----------------------------------------------------------------------
        'folke/ts-comments.nvim',
        opts = {},
        event = 'VeryLazy',
        enabled = vim.fn.has('nvim-0.10.0') == 1,
    },
}
