local harpoon = require('harpoon')
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
local term = require('harpoon.term')

local defaut_opts = {
  global_settings = {
    save_on_toggle = true,
    save_on_change = true,
    enter_on_sendcmd = false,
    tmux_autoclose_windows = false,
    excluded_filetypes = { 'harpoon' },
    mark_branch = false,
    tabline = false,
    tabline_prefix = '   ',
    tabline_suffix = '   ',
  },
  menu = {
    width = vim.api.nvim_win_get_width(0) - 10,
  },
}


mark.add_file_and_notify = function()
  mark.add_file()
  vim.notify(
    'Added: ' .. tostring(vim.fn.expand('%')),
    vim.log.levels.INFO,
    { title = 'Harpoon',
      timeout = 100,
    }

  )
end

ui.on_attach = {}
local my_weird_keymaps = {
  e = 1,
  a = 2,
  h = 3,
  i = 4,
  s = 5,
  k = 6,
  r = 7,
  c = 8,
  n = 9,
}

function ui.on_attach.set_on_keymaps_harpoon_enter()
  local function set_keymap(index, keycode)
    vim.keymap.set('n', keycode, function()
      local line_count = vim.api.nvim_buf_line_count(0)
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      if current_line ~= index and index <= line_count then
        vim.cmd('normal! ' .. index .. 'G')
      end
      vim.cmd('lua require(\'harpoon.ui\').select_menu_item()')
      vim.cmd('normal! <CR>')
    end, { silent = true, buffer = 0, nowait = true })
  end
  for harpoon_key, index in pairs(my_weird_keymaps) do
    set_keymap(index, harpoon_key)
  end
end

function ui.on_attach.unset_on_keymaps_harpoon_enter()
  local function unset_keymap(key)
    vim.keymap.del('n', key)
    -- Check if the keymap is still there
    if vim.api.nvim_buf_get_keymap(0, 'n')[key] then
      vim.notify(
        'Failed to unset keymap: ' .. key,
        vim.log.levels.ERROR,
        { title = 'Harpoon' }
      )
    end
  end
  for my_key, harpoon_key in pairs(my_weird_keymaps) do
    unset_keymap(my_key)
    unset_keymap(harpoon_key)
  end
end

vim.api.nvim_create_augroup('Harpoon', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'harpoon',
  command = 'lua require(\'harpoon.ui\').on_attach.set_on_keymaps_harpoon_enter()',
  group = 'Harpoon',
})
-- vim.api.nvim_create_autocmd(
--         { "BufLeave" },
--         {
--                 pattern = "harpoon",
--                 command = "lua require('harpoon.ui').on_attach.unset_on_keymaps_harpoon_enter()",
--                 group = "Harpoon"
--         })

vim.keymap.set(
  'n',
  '<leader>a',
  mark.add_file_and_notify,
  { silent = true, desc = 'add file to harpoon' }
)
vim.keymap.set('n', '<leader>j', function()
  ui.toggle_quick_menu()
end, { silent = true, desc = 'toggle harpoon menu' })
vim.keymap.set(
  'n',
  '<leader>t',
  term.gotoTerminal,
  { silent = true, desc = 'go to terminal' }
)
vim.keymap.set('n', '<C-e>', function()
  ui.nav_file(1)
end, { silent = true, desc = 'navigate to harpoon file 1' })
vim.keymap.set('n', '<C-a>', function()
  ui.nav_file(2)
end, { silent = true, desc = 'navigate to harpoon file 2' })
vim.keymap.set('n', '<C-h>', function()
  ui.nav_file(3)
end, { silent = true, desc = 'navigate to harpoon file 3' })
vim.keymap.set('n', '<C-i>', function()
  ui.nav_file(4)
end, { silent = true, desc = 'navigate to harpoon file 4' })

harpoon.setup(defaut_opts)
