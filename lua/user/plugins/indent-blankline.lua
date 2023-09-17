vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:▸ "
vim.opt.listchars:append "trail:·"
vim.opt.listchars:append "extends:❯"
vim.opt.listchars:append "precedes:❮"

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = false,
    show_current_context_start = false,
}
