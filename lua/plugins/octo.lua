return {
    {
        -- [octo.nvim](https://github.com/pwntester/octo.nvim)
        -- Octo.nvim is a GitHub CLI client for Neovim written in Lua.
        ----------------------------------------------------------------------
        'pwntester/octo.nvim',
        lazy = true,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
    },
}
