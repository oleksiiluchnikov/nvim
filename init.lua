pcall(require, 'config.options')
pcall(require, 'config.mappings')
pcall(require, 'config.lazy')
pcall(require, 'config.utils')
pcall(require, 'config.autocmds')

local config_dir = string.format('%s/lua/config', vim.fn.stdpath('config'))
-- Load all lua files in the config directory
for _, entry in ipairs(vim.fn.readdir(config_dir) or {}) do
    if entry == 'init.lua' then
        goto continue
    end
    local module_path = string.format('config.%s', entry:gsub('%.lua$', ''))
    local status, err = pcall(require, module_path)
    if not status then
        print(string.format('Failed to load module %s: %s', module_path, err))
    end
    ::continue::
end

vim.cmd('silent! colorscheme catppuccin')
vim.cmd('silent! ShowkeysToggle')
