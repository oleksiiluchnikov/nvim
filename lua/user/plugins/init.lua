local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if vim.fn.isdirectory(lazypath) == 0 then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        -- '--branch=stable', -- latest stable release
        lazypath,
    })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
local plugins = {}

---Adds a plugin to the list of plugins to be loaded lazily
---@param plugin table
local function use(plugin)
    table.insert(plugins, plugin)
end

-- Provides utility functions for Neovim Lua development
use({
    "nvim-lua/plenary.nvim",
})

use({
    "supermaven-inc/supermaven-nvim",
    config = function()
        require("user.plugins.supermaven")
    end,
})

-- Offers a popup API for Neovim Lua plugins
use({
    "nvim-lua/popup.nvim",
})

-- LSP kind icons
use({
    "onsails/lspkind-nvim",
})

-- Indent blankline: Indents blank lines for Neovim
use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        require("user.plugins.indent-blankline")
    end,
})

use({
    "Aasim-A/scrollEOF.nvim",
    config = function()
        require("scrollEOF").setup()
    end,
})

-- Creates a light and configurable status line for Neovim
use({
    "nvim-lualine/lualine.nvim",
    config = function()
        require("user.plugins.lualine")
    end,
})

-- Fuzzy finder with a rich plugin ecosystem
use({
    "nvim-telescope/telescope.nvim",
    config = function()
        require("user.plugins.telescope")
    end,
})

-- Telescope extension for repository management
use({
    "cljoly/telescope-repo.nvim",
})

-- Implements a command palette using Telescope
use({
    "LinArcX/telescope-command-palette.nvim",
})

-- Allows browsing bookmarks with Telescope
use({
    "dhruvmanila/telescope-bookmarks.nvim",
})

-- Provides a file browser for Telescope
use({
    "nvim-telescope/telescope-file-browser.nvim",
})

-- Integrates GitHub with Telescope. See: https://github.com/nvim-telescope/telescope-github.nvim
use({
    "nvim-telescope/telescope-github.nvim",
})

-- Adds UI selection support for Telescope
use({
    "nvim-telescope/telescope-ui-select.nvim",
})

-- Offers FZF sorter for Telescope
use({
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
})

-- Provides Zoxide integration for Telescope
use({
    "jvgrootveld/telescope-zoxide",
})

-- Supports frecent files for Telescope
use({
    "nvim-telescope/telescope-frecency.nvim",
})

-- Displays color previews for Telescope
use({
    "uga-rosa/ccc.nvim",
    config = function()
        require("user.plugins.ccc")
    end,
})

-- Enables distraction-free writing mode
use({
    "preservim/vim-pencil",
})

-- Allows marking and navigating to files/buffers
use({
    "ThePrimeagen/harpoon",
    config = function()
        vim.defer_fn(function()
            require("user.plugins.harpoon")
        end, 100)
    end,
    event = "BufEnter",
})

-- Visualizes undo history as a tree
use({
    "mbbill/undotree",
})

-- Acts as a Git wrapper for Neovim
use({
    "tpope/vim-fugitive",
})

-- Simplifies manipulation of surrounding text
use({
    "tpope/vim-surround",
})

-- Allows previewing media files with Telescope
use({
    "nvim-telescope/telescope-media-files.nvim",
})

use({
    "nvim-telescope/telescope-packer.nvim",
})

-- Keeps the cursor centered on the screen
use({
    "arnamak/stay-centered.nvim",
    config = function()
        require("stay-centered")
    end,
})

-- Acts as a snippet engine for Lua
use({
    "L3MON4D3/LuaSnip",
})

-- Provides LuaSnip completion source for nvim-cmp
use({
    "saadparwaiz1/cmp_luasnip",
})

-- Implements a minimal LSP client for Neovim
use({
    "VonHeikemen/lsp-zero.nvim",
    config = function()
        require("user.plugins.lsp")
    end,
    branch = "v3.x",
})

-- Offers a collection of LSP configurations
use({
    "neovim/nvim-lspconfig",
})

-- Provides inlay hints for LSP
use({
    "lvimuser/lsp-inlayhints.nvim",
    opts = {},
    lazy = true,
    init = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
            callback = function(args)
                if not (args.data and args.data.client_id) then
                    return
                end
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                require("lsp-inlayhints").on_attach(client, args.buf)
            end,
        })
    end,
})

-- Formats code using LSP
use({
    "lukas-reineke/lsp-format.nvim",
})

-- Displays status messages for LSP
use({
    "nvim-lua/lsp-status.nvim",
})

-- Manages projects and sessions
use({
    "williamboman/mason.nvim",
    config = function()
        require("user.plugins.mason")
    end,
})

-- Provides LSP configuration for Mason
use({
    "williamboman/mason-lspconfig.nvim",
})

-- Acts as an autocomplete framework for Neovim
use({
    "hrsh7th/nvim-cmp",
    config = function()
        require("user.plugins.cmp")
    end,
})

-- Provides LSP source for nvim-cmp
use({
    "hrsh7th/cmp-nvim-lsp",
})

-- Offers signature help for LSP completion
use({
    "hrsh7th/cmp-nvim-lsp-signature-help",
})

-- Adds Neovim Lua source for nvim-cmp
use({
    "hrsh7th/cmp-nvim-lua",
})

-- Integrates Vsnip source with nvim-cmp
use({
    "hrsh7th/cmp-vsnip",
})

-- Supplies file path source for nvim-cmp
use({
    "hrsh7th/cmp-path",
})

-- Includes buffer source for nvim-cmp
use({
    "hrsh7th/cmp-buffer",
})

-- Offers LuaSnip source for nvim-cmp
-- add({
--   'saadparwaiz1/cmp_luasnip',
-- })

-- Provides cmdline source for nvim-cmp
use({
    "hrsh7th/cmp-cmdline",
})

-- Displays icons on completions
use({
    "onsails/lspkind-nvim",
})

-- Enhances sorting for cmp
use({
    "lukas-reineke/cmp-under-comparator",
})

-- LSP client for Obsidian
use({
    "gw31415/obsidian-lsp",
    config = function()
        require("user.plugins.obsidian-lsp")
    end,
})

-- Provides core Treesitter functionality
use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("user.plugins.treesitter")
    end,
    build = ":TSUpdate",
})

-- Enables refactoring using Treesitter
use({
    "nvim-treesitter/nvim-treesitter-refactor",
})

-- Supports AppleScript syntax highlighting
use({
    "vim-scripts/applescript.vim",
})

-- Creates colorful brackets using Treesitter
use({
    "p00f/nvim-ts-rainbow",
})

-- Acts as a Treesitter playground for Neovim
use({
    "nvim-treesitter/playground",
})

-- Provides text objects using Treesitter
-- FIXME: This plugin is broken
-- use({
--     "nvim-treesitter/nvim-treesitter-textobjects",
--     dependencies = {
--         "nvim-treesitter/nvim-treesitter",
--     },
-- })

-- Integrates a debugger with Neovim
-- add({
--   'puremourning/vimspector',
-- })

-- Acts as a commenting plugin
use({
    "numToStr/Comment.nvim",
    config = function()
        require("user.plugins.comment")
    end,
})

-- Provides a text alignment plugin
use({
    "godlygeek/tabular",
})

-- Highlights matching text under the cursor
use({
    "RRethy/vim-illuminate",
})

-- Manages the clipboard for Neovim
use({
    "AckslD/nvim-neoclip.lua",
})

-- Enhances word motions
use({
    "chaoren/vim-wordmotion",
})

-- Allows easy text case changes
use({
    "johmsalas/text-case.nvim",
})

-- Acts as a key binding helper
-- add({
--   'folke/which-key.nvim',
--   config = function()
--     require('user.plugins.which-key')
--   end,
-- })

-- Adds core Copilot integration
use({
    "zbirenbaum/copilot.lua",
    event = "VimEnter",
    config = function()
        vim.defer_fn(function()
            require("user.plugins.copilot")
        end, 100)
    end,
})

use({
    "jonahgoldwastaken/copilot-status.nvim",
    event = "BufReadPost",
})

-- Neovim client for Language Server Protocol
use({
    "catppuccin/nvim",
    config = function()
        require("user.plugins.catppuccin")
    end,
    priority = 1000,
    lazy = true,
})

-- Obsidian.nvim
use({
    "epwalsh/obsidian.nvim",
    config = function()
        require("user.plugins.obsidian")
    end,
})

-- Lua plugin development for Neovim
use({
    "folke/neodev.nvim",
    config = function()
        require("user.plugins.neodev")
    end,
})

-- Hammerspoon integration for Neovim
use({
    "oleksiiluchnikov/hs.nvim",
    dir = vim.fn.expand("~/hs.nvim"),
    dev = true,
})

-- Jumps in JSON
use({
    "theprimeagen/jvim.nvim",
    config = function()
        require("user.plugins.jvim")
    end,
})

-- Centerpad
use({
    "smithbm2316/centerpad.nvim",
})

-- Better quickfix
use({
    "kevinhwang91/nvim-bqf",
    config = function()
        require("user.plugins.bqf")
    end,
    event = "LspAttach",
})

-- Diagnostic information viewer
use({
    "dgagn/diagflow.nvim",
    event = "LspAttach",
})

-- Code formatter
use({
    "mhartington/formatter.nvim",
    config = function()
        require("user.plugins.formatter")
    end,
})

-- Glow markdown preview
use({
    "npxbr/glow.nvim",
    config = function()
        require("user.plugins.glow")
    end,
})

-- Sniprun
use({
    "michaelb/sniprun",
    config = function()
        require("user.plugins.sniprun")
    end,
    run = "zsh ./install.sh",
})

-- Troube: A pretty, fast, and lean diagnostics manager
use({
    "folke/Trouble.nvim",
})

-- Todo comments: highlight, list and search todo comments in your projects
use({
    "folke/todo-comments.nvim",
})

use({
    "rcarriga/nvim-notify",
})

use({
    "lewis6991/gitsigns.nvim",
    config = function()
        require("user.plugins.gitsigns")
    end,
})

use({
    "jakewvincent/mkdnflow.nvim",
    config = function()
        require("user.plugins.mkdnflow")
    end,
})

use({
    "axkirillov/easypick.nvim",
    config = function()
        require("user.plugins.easypick")
    end,
})

use({
    "jackMort/ChatGPT.nvim",
    config = function()
        vim.defer_fn(function()
            require("user.plugins.chatgpt")
        end, 100)
    end,
})

use({
    "MunifTanjim/nui.nvim",
})

use({
    "ThePrimeagen/vim-be-good",
})

use({
    "oleksiiluchnikov/vault.nvim",
    dir = vim.fn.expand("~/vault.nvim"),
    config = function()
        vim.defer_fn(function()
            require("user.plugins.vault")
        end, 100)
    end,
})

use({
    "rebelot/kanagawa.nvim",
    config = function()
        require("user.plugins.kanagawa")
    end,
})

use({
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("user.plugins.oil")
    end,
})

use({
    "oleksiiluchnikov/telescope-dotfiles.nvim",
    dir = vim.fn.expand("~/telescope-dotfiles.nvim"),
})

use({
    "oleksiiluchnikov/eagle.nvim",
    dir = vim.fn.expand("~/eagle.nvim"),
})
--
-- add({
--   'hinell/lsp-timeout.nvim',
--   dependencies = { 'neovim/nvim-lspconfig' },
-- })

use({
    "edluffy/hologram.nvim",
})

use({
    "oleksiiluchnikov/gradient.nvim",
    dir = vim.fn.expand("~/gradient.nvim"),
})

use({
    "oleksiiluchnikov/dates.nvim",
    dir = vim.fn.expand("~/dates.nvim"),
})

use({
    "simrat39/symbols-outline.nvim",
    config = function()
        require("user.plugins.symbols-outline")
    end,
})

use({
    "bennypowers/nvim-regexplainer",
    config = function()
        require("user.plugins.regexplainer")
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "MunifTanjim/nui.nvim",
    },
})

use({
    "projekt0n/github-nvim-theme",
})

use({
    "simrat39/inlay-hints.nvim",
    config = function()
        require("inlay-hints").setup({
            only_current_line = true,

            eol = {
                right_align = true,
            },
        })
    end,
})

use({
    "piersolenski/wtf.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        -- require('user.plugins.wtf')
        vim.defer_fn(function()
            require("user.plugins.wtf")
        end, 200)
    end,
})

use({
    "dpayne/CodeGPT.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.defer_fn(function()
            require("codegpt.config")
        end, 200)
    end,
})

use({
    "AckslD/messages.nvim",
    config = function()
        require("user.plugins.messages")
    end,
})

use({
    "sourcegraph/sg.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
        config = function()
            require("user.plugins.sg")
        end,
    },
})

use({
    "pwntester/octo.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        -- require("octo").setup()
        require("user.plugins.octo")
    end,
})

-- oil.nvim
use({
    "stevearc/oil.nvim",
    config = function()
        require("user.plugins.oil")
    end,
})

require("lazy").setup(plugins, {})
