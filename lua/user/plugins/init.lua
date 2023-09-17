local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    --------------------------------------------------------------------------
    -- For general-purpose utilities
    --------------------------------------------------------------------------
    'nvim-lua/plenary.nvim',         -- Provides utility functions for Neovim Lua development
    'nvim-lua/popup.nvim',           -- Offers a popup API for Neovim Lua plugins
    {
        'nvim-lualine/lualine.nvim', -- Creates a light and configurable status line for Neovim
        config = function()
            require("user.plugins.lualine")
        end
    },

    --------------------------------------------------------------------------
    -- Telescope and its extensions (fuzzy finder and related functionality)
    --------------------------------------------------------------------------
    'nvim-telescope/telescope.nvim',              -- Fuzzy finder with a rich plugin ecosystem
    'cljoly/telescope-repo.nvim',                 -- Telescope extension for repository management
    'LinArcX/telescope-command-palette.nvim',     -- Implements a command palette using Telescope
    'dhruvmanila/telescope-bookmarks.nvim',       -- Allows browsing bookmarks with Telescope
    'nvim-telescope/telescope-file-browser.nvim', -- Provides a file browser for Telescope
    'nvim-telescope/telescope-github.nvim',       -- Integrates GitHub with Telescope. See: https://github.com/nvim-telescope/telescope-github.nvim
    'nvim-telescope/telescope-ui-select.nvim',    -- Adds UI selection support for Telescope
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    },                                        -- Offers FZF sorter for Telescope
    'jvgrootveld/telescope-zoxide',           -- Provides Zoxide integration for Telescope
    'nvim-telescope/telescope-frecency.nvim', -- Supports frecent files for Telescope
    --------------------------------------------------------------------------
    'uga-rosa/ccc.nvim',                      -- Displays color previews for Telescope
    'preservim/vim-pencil',                   -- Enables distraction-free writing mode
    'ThePrimeagen/harpoon',                   -- Allows marking and navigating to files/buffers
    'mbbill/undotree',                        -- Visualizes undo history as a tree
    'tpope/vim-fugitive',                     -- Acts as a Git wrapper for Neovim
    'tpope/vim-surround',                     -- Simplifies manipulation of surrounding text
    'nvim-telescope/telescope-media-files.nvim', -- Allows previewing media files with Telescope
    {
        'arnamak/stay-centered.nvim',
        config = function()
            require('stay-centered')
        end
    }, -- Keeps the cursor centered on the screen

    --------------------------------------------------------------------------
    -- Snippet engines and related functionality
    --------------------------------------------------------------------------
    'L3MON4D3/LuaSnip',         -- Acts as a snippet engine for Lua
    "saadparwaiz1/cmp_luasnip", -- Provides LuaSnip completion source for nvim-cmp

    --------------------------------------------------------------------------
    -- For LSP (Language Server Protocol) support
    --------------------------------------------------------------------------
    'VonHeikemen/lsp-zero.nvim',    -- Implements a minimal LSP client for Neovim
    'neovim/nvim-lspconfig',        -- Offers a collection of LSP configurations
    'lvimuser/lsp-inlayhints.nvim', -- Provides inlay hints for LSP

    --------------------------------------------------------------------------
    -- Mason - LSP package manager
    --------------------------------------------------------------------------
    'williamboman/mason.nvim',           -- Manages projects and sessions
    'williamboman/mason-lspconfig.nvim', -- Provides LSP configuration for Mason


    --------------------------------------------------------------------------
    -- nvim-cmp autocomplete framework and its extensions
    --------------------------------------------------------------------------
    'hrsh7th/nvim-cmp',                    -- Acts as an autocomplete framework for Neovim
    'hrsh7th/cmp-nvim-lsp',                -- Provides LSP source for nvim-cmp
    'hrsh7th/cmp-nvim-lsp-signature-help', -- Offers signature help for LSP completion
    'hrsh7th/cmp-nvim-lua',                -- Adds Neovim Lua source for nvim-cmp
    'hrsh7th/cmp-vsnip',                   -- Integrates Vsnip source with nvim-cmp
    'hrsh7th/cmp-path',                    -- Supplies file path source for nvim-cmp
    'hrsh7th/cmp-buffer',                  -- Includes buffer source for nvim-cmp
    'saadparwaiz1/cmp_luasnip',            -- Offers LuaSnip source for nvim-cmp
    'hrsh7th/cmp-cmdline',                 -- Provides cmdline source for nvim-cmp
    'onsails/lspkind-nvim',                -- Displays icons on completions
    'lukas-reineke/cmp-under-comparator',  -- Enhances sorting for cmp

    -- --------------------------------------------------------------------------
    -- -- Treesitter syntax highlighting and related functionality
    -- --------------------------------------------------------------------------
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },                                             -- Provides core Treesitter functionality
    'nvim-treesitter/nvim-treesitter-refactor',    -- Enables refactoring using Treesitter
    'vim-scripts/applescript.vim',                 -- Supports AppleScript syntax highlighting
    'p00f/nvim-ts-rainbow',                        -- Creates colorful brackets using Treesitter
    'nvim-treesitter/playground',                  -- Acts as a Treesitter playground for Neovim
    'nvim-treesitter/nvim-treesitter-textobjects', -- Provides text objects using Treesitter
    'puremourning/vimspector',                     -- Integrates a debugger with Neovim
    'numToStr/Comment.nvim',                       -- Acts as a commenting plugin
    'godlygeek/tabular',                           -- Provides a text alignment plugin
    -- 'renerocksai/telekasten.nvim',                 -- Integrates Zettelkasten with Neovim
    'RRethy/vim-illuminate',                       -- Highlights matching text under the cursor
    'AckslD/nvim-neoclip.lua',                     -- Manages the clipboard for Neovim
    'chaoren/vim-wordmotion',                      -- Enhances word motions
    'johmsalas/text-case.nvim',                    -- Allows easy text case changes
    "folke/which-key.nvim",                        -- Acts as a key binding helper
    --------------------------------------------------------------------------
    -- Copilot AI-assisted code completion
    --------------------------------------------------------------------------
    {
        'zbirenbaum/copilot.lua', -- Adds core Copilot integration
        event = 'VimEnter',
        config = function()
            vim.defer_fn(function()
                require('user.plugins.copilot')
            end, 100)
        end,
    },
    {
        "jonahgoldwastaken/copilot-status.nvim",
        event = "BufReadPost",
    },
    --------------------------------------------------------------------------
    -- Debugging and testing
    --------------------------------------------------------------------------
    {
        'folke/trouble.nvim', -- Diagnostic information viewer
        dependencies = {
            'kyazdani42/nvim-web-devicons',
            'nvim-lua/plenary.nvim'
        }
    },

    --------------------------------------------------------------------------
    -- Terminal and shell related functionality
    --------------------------------------------------------------------------
    {
        "Shougo/vimproc.vim",
        build = "make"
    },                                     -- Supports asynchronous execution for Vim
    "Shougo/vimshell.vim",                 -- Adds an interactive shell for Vim
    "Shougo/vimfiler.vim",                 -- Acts as a file explorer for Vim
    "lukas-reineke/indent-blankline.nvim", -- Show indent markers
    "Vonr/align.nvim",                     -- Align text easily
    "Shougo/deol.nvim",                    -- Terminal buffer for Neovim
    "rcarriga/nvim-notify",                -- Customizable notifications for Neovim
    {
        'oleksiiluchnikov/rose-pine.nvim',
        name = 'rose-pine'
    },                        -- Rose Pine colorscheme

    {
        'ellisonleao/gruvbox.nvim',
    },

    -- "David-Kunz/markid", -- TODO: THink about this why I need it

    --------------------------------------------------------------------------
    -- Rust development tools
    --------------------------------------------------------------------------

    "simrat39/rust-tools.nvim",      -- Rust development tools for Neovim
    "simrat39/symbols-outline.nvim", -- Symbol outline for Neovim
    --------------------------------------------------------------------------
    -- Git related functionality
    --------------------------------------------------------------------------
    'lewis6991/gitsigns.nvim',       -- Show Git signs in the sign column
      {
    'renerocksai/telekasten.nvim',
    dependencies = {'nvim-telescope/telescope.nvim'}
  },
    'folke/noice.nvim',             -- Adds noise to the background
    'jakewvincent/mkdnflow.nvim',   -- Markdown editing for Neovim
    -- glow
    'ellisonleao/glow.nvim',         -- Markdown preview for Neovim
    'catppuccin/nvim'             -- Neovim client for the Language Server Protocol
}

require('lazy').setup(plugins, {})

-- -- Plugin configurations
-- local configs = {
--     'telescope',
--    'treesitter',
--     'harpoon',
--     'mason',
--     'lsp',
--     'cmp',
--     'diagnostics',
--     'indent-blankline',
--     'neovide',
--     'gitsigns',
--     'which-key',
--     'ccc',
--     'rose-pine',
--     'gruvbox',
--     'comment',
--     'telekasten',
--     'mkdnflow',
--     'catppuccin',
-- }
--
--     for _, config in ipairs(configs) do
--         require('user.plugins.' .. config)
--     end
--
--
--

require('user.plugins.telescope')
require('user.plugins.treesitter')
require('user.plugins.harpoon')
require('user.plugins.mason')
require('user.plugins.lsp')
require('user.plugins.cmp')
require('user.plugins.diagnostics')
require('user.plugins.indent-blankline')
require('user.plugins.neovide')
require('user.plugins.gitsigns')
require('user.plugins.which-key')
require('user.plugins.ccc')
require('user.plugins.rose-pine')
require('user.plugins.gruvbox')
require('user.plugins.comment')
require('user.plugins.telekasten')
require('user.plugins.mkdnflow')
require('user.plugins.catppuccin')
