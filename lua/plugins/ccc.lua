return {
    {
        -- [ccc.nvim](https://github.com/uga-rosa/ccc.nvim)
        -- Displays color previews for Telescope and color picker
        -----------------------------------------------------------------------
        'uga-rosa/ccc.nvim',
        init = function()
            vim.opt.termguicolors = true
        end,
        opts = {
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        },
    },
}
