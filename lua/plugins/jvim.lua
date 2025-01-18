return {
    {
        -- [jvim.nvim](https://github.com/theprimeagen/jvim.nvim)
        -- Jumps in JSON
        -----------------------------------------------------------------------
        'theprimeagen/jvim.nvim',
        ft = {
            'json',
        },
        keys = {
            {
                '<left>',
                '<cmd>lua require("jvim").to_parent()<CR>',
                desc = 'Move to parent node in JSON',
            },
            {
                '<right>',
                '<cmd>lua require("jvim").descend()<CR>',
                desc = 'Descend into JSON node',
            },
            {
                '<up>',
                '<cmd>lua require("jvim").prev_sibling()<CR>',
                desc = 'Move to previous sibling node in JSON',
            },
            {
                '<down>',
                '<cmd>lua require("jvim").next_sibling()<CR>',
                desc = 'Move to next sibling node in JSON',
            },
        },
    },
}
