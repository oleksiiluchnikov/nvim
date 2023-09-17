vim.user = {}
-- Settings
require('user.constants')
require("user.options")
require("user.plugins")
require("user.commands")
require("user.autocommands")
require('user.mappings')
require('user.functions')


-- Redeclare the global modules
vim.notify = require('notify') -- fancy notifications
-- vim.cmd('colorscheme sonokai')
vim.cmd('colorscheme catppuccin')

-- Highlighting for diagnostics
-------------------------------------------------------------------------------
vim.cmd('highlight LspInlayHint guifg=#2a5175 guibg=NONE')
