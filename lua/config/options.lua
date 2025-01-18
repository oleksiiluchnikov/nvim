---@diagnostic disable: inject-field
-- Set the leader key to Space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- Set the local leader key to Space

-- Font and UI settings
vim.g.have_nerd_font = true -- Set to true if you have a nerd font
vim.g.netrw_banner = 0 -- Disable netrw banner
vim.g.italic_comments = false -- Disable italic comments
vim.g.netrw_list_hide = '.DS_Store' -- Ignore .DS_Store files in netrw
vim.g.netrw_browse_split = 0 -- Open netrw in the current window

-- Scrolling and window splitting
vim.opt.scrolloff = 999 -- Set the scrolloff to 999
vim.opt.splitright = true -- Split windows vertically to the right

-- Text editing
vim.opt.wrap = false -- Disable line wrapping
vim.opt.signcolumn = 'yes' -- Show sign column
vim.opt.guicursor = '' -- Hide the cursor in GUI mode
vim.opt.termguicolors = true -- Use true color in the terminal
vim.opt.nu = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.formatoptions = 'crqnj' -- Set the format options
vim.opt.tabstop = 4 -- Set the tabstop to 4 spaces
vim.opt.softtabstop = 4 -- Set the soft tabstop to 4 space
vim.opt.shiftwidth = 4 -- Set the shiftwidth to 4 spaces
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Enable smart indentation

-- File management
vim.opt.swapfile = false -- Disable swap file creation
vim.opt.backup = false -- Disable backup file creation
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- Set the undo directory
vim.opt.undofile = true -- Enable undo persistence

-- Search and completion
vim.opt.hlsearch = true -- Enable search highlighting
vim.opt.incsearch = true -- Incremental search
vim.opt.isfname:append('@-@') -- Include '@' in isfname
vim.opt.updatetime = 50 -- Set the update time
vim.opt.colorcolumn = '80' -- Highlight the 80th column
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' } -- Set the complete options
vim.opt.shortmess = vim.opt.shortmess + { c = true } -- Disable completion messages
vim.opt.updatetime = 300 -- Set the update time
vim.opt.shada = { '!', '\'1000', '<50', 's10', 'h' } -- Set the ShaDa options to save the history

vim.opt.laststatus = 3

-- Logging
vim.env.NVIM_LSP_LOG_FILE = '/tmp/nvim.log'
vim.notify('Options loaded')
