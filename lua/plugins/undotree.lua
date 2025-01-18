return {
    {
        -- [undotree.nvim](https://github.com/mbbill/undotree)
        -- Visualizes undo history as a tree
        -----------------------------------------------------------------------
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {
                remap = false,
                silent = true,
            })
        end,
    },
}
