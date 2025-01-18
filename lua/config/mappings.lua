--- Global mappings
-------------------------------------------------------------------------------
-- Navigation
vim.keymap.set({ 'n', 'v' }, '<up>', function()
    require('config.utils').jump_to_next_line_with_same_indent(
        false,
        { 'end', '-' }
    )
end, {
    desc = 'move to previous line with same indentation or if blink.cmp.is_visible() then blink.cmp.select_prev() end',
})
vim.keymap.set({ 'n', 'v' }, '<down>', function()
    require('config.utils').jump_to_next_line_with_same_indent(
        true,
        { 'end', '-' }
    )
end, {
    desc = 'move to next line with same indentation or if blink.cmp.is_visible() then blink.cmp.select_next() end',
})
vim.keymap.set('n', '<left>', '<C-w>h', { desc = 'focus left window' })
vim.keymap.set('n', '<right>', '<C-w>l', { desc = 'focus right window' })
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { desc = 'move line up' })
vim.keymap.set('v', 'K', ':m \'>-2<CR>gv=gv', { desc = 'move line down' })
