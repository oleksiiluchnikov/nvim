-- https://github.com/simrat39/inlay-hints.nvim
-- Description: Plugin to show inline hints in the code
return {
    {
        'simrat39/inlay-hints.nvim',
        config = function()
            require('inlay-hints').setup({
                only_current_line = true,
                eol = {
                    right_align = true,
                },
            })
        end,
    },
}
