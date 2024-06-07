require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = "<C-j>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-y>",
    },
    ignore_filetypes = { cpp = true },
    color = {
        suggestion_color = "#ffffff",
        cterm = 244,
    },
    disable_inline_completion = true, -- disables inline completion for use with cmp
    disable_keymaps = false, -- disables built in keymaps for more manual control
})
