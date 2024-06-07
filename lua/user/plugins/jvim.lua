-- nnoremap <left> :lua require("jvim").to_parent()<CR>
-- nnoremap <right> :lua require("jvim").descend()<CR>
-- nnoremap <up> :lua require("jvim").prev_sibling()<CR>
-- nnoremap <down> :lua require("jvim").next_sibling()<CR>

vim.keymap.set('n', '<left>', '<cmd>lua require("jvim").to_parent()<CR>', {
    noremap = true,
    silent = true,
    desc = 'Move to parent node in JSON'
})
vim.keymap.set('n', '<right>', '<cmd>lua require("jvim").descend()<CR>', {
    noremap = true,
    silent = true,
    desc = 'Descend into JSON node'
})

vim.keymap.set('n', '<up>', '<cmd>lua require("jvim").prev_sibling()<CR>', {
    noremap = true,
    silent = true,
    desc = 'Move to previous sibling node in JSON'
})
vim.keymap.set('n', '<down>', '<cmd>lua require("jvim").next_sibling()<CR>', {
    noremap = true,
    silent = true,
    desc = 'Move to next sibling node in JSON'
})

