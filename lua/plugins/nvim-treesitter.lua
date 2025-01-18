return {
    {
        -- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
        -- Treesitter is a new parser generator tool that we can
        -- use in Neovim to power faster and more accurate
        -- syntax highlighting.
        'nvim-treesitter/nvim-treesitter',
        version = false, -- last release is way too old and doesn't work on Windows
        build = ':TSUpdate',
        event = 'VeryLazy',
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treesitter** module to be loaded in time.
            -- Luckily, the only things that those plugins need are the custom queries, which we make available
            -- during startup.
            require('lazy.core.loader').add_to_rtp(plugin)
            require('nvim-treesitter.query_predicates')
        end,
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        keys = {
            { '<c-space>', desc = 'Increment Selection' },
            { '<bs>', desc = 'Decrement Selection', mode = 'x' },
        },
        opts_extend = { 'ensure_installed' },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
                language = {
                    dataviewjs = 'javascript',
                },
            },
            indent = { enable = true },
            ensure_installed = {
                'bash',
                'c',
                'clojure',
                'comment',
                'css',
                'diff',
                'go',
                'html',
                'javascript',
                'jsdoc',
                'json',
                'jsonc',
                'lua',
                'luadoc',
                'luap',
                'markdown',
                'markdown_inline',
                'printf',
                'python',
                'query',
                'regex',
                'rust',
                'svelte',
                'sxhkdrc',
                'teal',
                'toml',
                'tsx',
                'typescript',
                'vim',
                'vimdoc',
                'xml',
                'yaml',
            },
            markid = {
                enable = true,
                -- disable = { "c", "rust" },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<C-space>',
                    node_incremental = '<C-space>',
                    scope_incremental = false,
                    node_decremental = '<bs>',
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']f'] = '@function.outer',
                        [']c'] = '@class.outer',
                        [']a'] = '@parameter.inner',
                        [']m'] = '@function.outer',
                        [']]'] = {
                            query = '@class.outer',
                            desc = 'Next class start',
                        },
                        [']o'] = '@loop.*',
                        [']s'] = {
                            query = '@scope',
                            query_group = 'locals',
                            desc = 'Next scope',
                        },
                        [']z'] = {
                            query = '@fold',
                            query_group = 'folds',
                            desc = 'Next fold',
                        },
                    },
                    goto_next_end = {
                        [']F'] = '@function.outer',
                        [']C'] = '@class.outer',
                        [']A'] = '@parameter.inner',
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[f'] = '@function.outer',
                        ['[c'] = '@class.outer',
                        ['[a'] = '@parameter.inner',
                        ['[m'] = '@function.outer',
                        ['[['] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[F'] = '@function.outer',
                        ['[C'] = '@class.outer',
                        ['[A'] = '@parameter.inner',
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                },
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = {
                            query = '@class.inner',
                            desc = 'Select inner part of a class region',
                        },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    include_surrounding_whitespace = true,
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
            },
            sync_install = true,
            auto_install = true,
            --- playground
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            },
        },
        ---@param opts TSConfig
        ---@diagnostic disable-next-line: unused-local
        config = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                opts.ensure_installed = opts.ensure_installed
            end
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
}
