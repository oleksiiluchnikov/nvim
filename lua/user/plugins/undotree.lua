vim.keymap.set(
  'n',
  '<leader>u',
  vim.cmd.UndotreeToggle,
  { 
    remap = false,
    silent = true
  }
)
