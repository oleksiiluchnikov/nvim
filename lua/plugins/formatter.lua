return {
    {
        -- [formatter.nvim](https://github.com/mhartington/formatter.nvim)
        -- Code formatter
        -----------------------------------------------------------------------
        'mhartington/formatter.nvim',
        config = function()
            local opts = {
                logging = false,
                log_level = vim.log.levels.WARN,
                filetype = {
                    lua = {
                        require('formatter.filetypes.lua').stylua,
                        function()
                            -- Supports conditional formatting
                            if
                                require('formatter.util').get_current_buffer_file_name()
                                == 'special.lua'
                            then
                                return nil
                            end

                            return {
                                exe = 'stylua',
                                args = {
                                    '--search-parent-directories',
                                    '--stdin-filepath',
                                    require('formatter.util').escape_path(
                                        require('formatter.util').get_current_buffer_file_path()
                                    ),
                                    '--',
                                    '-',
                                },
                                stdin = true,
                            }
                        end,
                    },
                    python = {
                        require('formatter.filetypes.python').black,
                        function()
                            return {
                                exe = 'black',
                                args = { '-' },
                                stdin = true,
                            }
                        end,
                    },
                    markdown = {
                        function(parser)
                            if not parser then
                                return {
                                    exe = 'prettier',
                                    args = {
                                        '--stdin-filepath',
                                        require('formatter.util').escape_path(
                                            require('formatter.util').get_current_buffer_file_path()
                                        ),
                                    },
                                    stdin = true,
                                    try_node_modules = true,
                                }
                            end

                            return {
                                exe = 'prettier',
                                args = {
                                    '--stdin-filepath',
                                    require('formatter.util').escape_path(
                                        require('formatter.util').get_current_buffer_file_path()
                                    ),
                                    '--parser',
                                    parser,
                                },
                                stdin = true,
                                try_node_modules = true,
                            }
                        end,
                    },
                    rust = {
                        function()
                            return {
                                exe = 'rustfmt',
                                args = {
                                    '--emit=stdout',
                                    '--edition=2021',
                                },
                                stdin = true,
                            }
                        end,
                    },

                    ['*'] = {
                        require('formatter.filetypes.any').remove_trailing_whitespace,
                    },
                },
            }
            require('formatter').setup(opts)
            local augroup_formatter =
                vim.api.nvim_create_augroup('__formatter__', {
                    clear = true,
                })

            vim.api.nvim_create_autocmd({ 'BufWritePre', 'InsertLeave' }, {
                pattern = '*',
                callback = function()
                    -- vim.cmd('Format')
                    pcall(vim.api.nvim_exec2, 'Format', {})
                end,
                group = augroup_formatter,
            })
        end,
    },
}
