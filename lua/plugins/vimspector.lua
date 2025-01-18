return {
    {
        -- [vimspector](https://github.com/puremourning/vimspector)
        -- Integrates a debugger with Neovim
        -----------------------------------------------------------------------
        'puremourning/vimspector',
        init = function()
            vim.cmd([[
            let g:vimspector_sidebar_width = 85
            let g:vimspector_bottombar_height = 15
            let g:vimspector_terminal_maxwidth = 70
            ]])
        end,
        lazy = true,
    },
}
