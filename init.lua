pcall(require, 'config.options')
pcall(require, 'config.lazy')
pcall(require, 'config.utils')
pcall(require, 'config.autocmds')

-- Load all lua files in the config directory
for _, entry in
    ipairs(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/config') or {})
do
    -- if init.lua is found, skip it
    if entry == 'init.lua' then
        goto continue
    end
    -- entry = entry:gsub('.lua$', '')
    if vim.fn.isdirectory(entry) == 0 then
        entry = entry:gsub('.lua$', '')
    end
    require('config.' .. entry)
    ::continue::
end
vim.cmd('silent! colorscheme catppuccin')
vim.cmd('silent! ShowkeysToggle')
