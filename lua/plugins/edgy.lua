return {
    {
        -- [edgy.nvim](https://github.com/folke/edgy.nvim)
        -- A Neovim plugin to easily create and manage predefined window layouts, bringing a new edge to your workflow.
        -----------------------------------------------------------------------
        'folke/edgy.nvim',
        optional = true,
        opts = function(_, opts)
            opts.right = opts.right or {}
            table.insert(opts.right, {
                ft = 'copilot-chat',
                title = 'Copilot Chat',
                size = { width = 50 },
            })
        end,
        lazy = true,
    },
}
