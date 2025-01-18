return {
    {
        -- [lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)
        -- Implements a minimal LSP client for Neovim
        -----------------------------------------------------------------------
        'VonHeikemen/lsp-zero.nvim',
        dependencies = { 'netmute/ctags-lsp.nvim' },
        config = function()
            local lspconfig = require('lspconfig')
            local lsp_zero = require('lsp-zero') -- LSP Zero plugin
            lsp_zero.extend_lspconfig()
            local mason = require('mason')
            mason.setup()
            local lspconfig_mason = require('mason-lspconfig')
            lspconfig_mason.setup()

            -- local available_servers = require('mason-lspconfig').get_available_servers()
            -- for _, server in ipairs(available_servers) do
            --     lsp_zero.default_setup(server)
            -- end

            --- @param client lspconfig.Config
            --- @param bufnr number
            --- @return nil
            local on_attach_lsp = function(client, bufnr)
                -- require("lsp-format").on_attach(client)
                --- TODO: Check does support_method exists
                --- @diagnostic disable-next-line: undefined-field
                if client.supports_method('textDocument/inlayHint') then
                    require('lsp-inlayhints').on_attach(client, bufnr)
                end
                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {
                    desc = 'open diagnostics in float window',
                    noremap = true,
                })
                vim.keymap.set('n', '[d', function()
                    -- Check if Trouble is toggled
                    if require('trouble').is_open() then
                        local trouble_last = require('trouble')._find_last()
                        if trouble_last == nil then
                            return
                        end
                        require('trouble').next(trouble_last, {
                            skip_groups = true,
                            jump = true,
                        })
                    else
                        vim.diagnostic.jump({
                            count = -1,
                            popup_opts = { border = 'rounded' },
                        })
                    end
                end, {
                    desc = 'go to previous diagnostic',
                    noremap = true,
                })
                vim.keymap.set('n', ']d', function()
                    -- require('trouble').previous({ skip_groups = true, jump = true })
                    if require('trouble').is_open() then
                        local trouble_last = require('trouble')._find_last()
                        if trouble_last == nil then
                            return
                        end
                        require('trouble').prev(trouble_last, {
                            skip_groups = true,
                            jump = true,
                        })
                    else
                        vim.diagnostic.jump({
                            count = 1,
                            popup_opts = { border = 'rounded' },
                        })
                    end
                end, {
                    desc = 'go to next diagnostic',
                    noremap = true,
                })
                vim.keymap.set(
                    'n',
                    '<leader>q',
                    vim.diagnostic.setloclist,
                    { desc = 'set loclist', noremap = true }
                )

                vim.keymap.set('n', '<leader>gd', function()
                    local current_repo_path = client.root_dir(
                        vim.fn.expand('%:p'),
                        vim.api.nvim_get_current_buf()
                    )
                    vim.cmd('cd ' .. current_repo_path)
                    local current_search
                    local ts_node = vim.treesitter.get_node()
                    if ts_node then
                        current_search = vim.treesitter.get_node_text(
                            ts_node,
                            vim.fn.bufnr()
                        )
                        if current_search == '' then
                            current_search = vim.fn.expand('<cword>')
                        end
                    else
                        current_search = vim.fn.expand('<cword>')
                    end
                    if type(current_search) == 'string' then
                        if string.find(current_search, '\n') then
                            return
                        end
                    end
                    require('telescope.builtin').grep_string({ -- use current word under cursor as query
                        search_dirs = {
                            current_repo_path,
                        },
                        word_match = '-w',
                        default_text = current_search,
                        path_display = { 'truncate' },
                    })
                end, {
                    desc = 'find definitions',
                    noremap = true,
                })
                vim.keymap.set('v', '<leader>gd', function()
                    local current_repo_path =
                        require('lspconfig.util').root_pattern('.git')(
                            vim.fn.expand('%:p:h')
                        )
                    vim.cmd('cd ' .. current_repo_path)
                    local current_search = vim.fn.getreg('g')
                    require('telescope.builtin').grep_string({ -- use current word under cursor as query
                        search_dirs = {
                            current_repo_path,
                        },
                        default_text = current_search,
                        word_match = '-w',
                        path_display = { 'smart' },
                        initial_mode = 'normal',
                    })
                end, {
                    desc = 'find definitions',
                    noremap = true,
                })

                -- Mapping
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set(
                    'n',
                    '<leader>wa',
                    vim.lsp.buf.add_workspace_folder,
                    opts
                )
                vim.keymap.set(
                    'n',
                    '<leader>wr',
                    vim.lsp.buf.remove_workspace_folder,
                    opts
                )
                vim.keymap.set('n', '<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set(
                    'n',
                    '<leader>D',
                    vim.lsp.buf.type_definition,
                    opts
                )
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set(
                    { 'n', 'v' },
                    '<leader>ca',
                    vim.lsp.buf.code_action,
                    opts
                )
                vim.keymap.set('n', 'gr', function()
                    -- cd to current file's directory until .git is found
                    require('telescope.builtin').lsp_references({
                        -- use current word under cursor as query
                        default_text = vim.fn.expand('<cword>'),
                    })
                end, { desc = 'find references', noremap = true })
                vim.keymap.set('n', '<leader>f', function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end
            vim.opt.signcolumn = 'yes'

            -- Bash, Shell, zsh etc
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local bashls = {
                on_attach = on_attach_lsp,
                cmd = { 'bash-language-server', 'start' },
                cmd_env = {
                    GLOB_PATTERN = '*@(.sh|.inc|.bash|.command)',
                },
                filetypes = { 'sh', 'zsh', 'bash', 'shell' },
            }
            lspconfig.bashls.setup(bashls)

            --- Check if spoon is mine by checking author field in init.lua
            ---
            ---@return boolean
            local function is_my_spoon(file_path)
                local function check_pattern(pattern)
                    local command = { 'grep', '-q', '-E', pattern, file_path }
                    return vim.fn.systemlist(command)
                end

                local username = vim.fn.system('whoami'):gsub('[\n\r]', '')
                local fullname = vim.fn
                    .system('git config --get user.name')
                    :gsub('[\n\r]', '')
                local email = vim.fn
                    .system('git config --get user.email')
                    :gsub('[\n\r]', '')

                -- Check for author
                for _, identifier in ipairs({ username, fullname, email }) do
                    local pattern = '^\\w+\\.author\\s*=\\s*.*'
                        .. identifier
                        .. '.*'
                    if #check_pattern(pattern) > 0 then
                        return true -- Authored by you
                    end
                end

                -- If the spoonPath contains your username, it's likely not authored by you.
                local exclude_pattern = 'spoonPath = ".*' .. username .. '.*"'
                if #check_pattern(exclude_pattern) > 0 then
                    return false -- Contains specific spoonPath, but not authored by you.
                end

                return false -- Default to not yours if no matching conditions.
            end

            --- Filter out diagnostics from spoons that are not authored by me.
            local function filter_spoon_diagnostics(err, result, ctx, cfg)
                -- Filter out diagnostics from '.*\.spoon/*'
                local spoon_path_pattern = '^file.*%.spoon.*$'
                if result.uri:match(spoon_path_pattern) then
                    if not result.uri:match('^.*init%.lua$') then
                        return
                    end
                    local file_path = require('config.utils')
                    ri_to_fname(result.uri)
                    if is_my_spoon(file_path) then
                        return vim.lsp.diagnostic.on_publish_diagnostics(
                            err,
                            result,
                            ctx,
                            cfg
                        )
                    end
                    return
                end
                return vim.lsp.diagnostic.on_publish_diagnostics(
                    err,
                    result,
                    ctx,
                    cfg
                )
            end

            --- Get the lua version of the current buffer
            ---
            ---@return string
            local function get_lua_version()
                local buffer_path = tostring(vim.fn.expand('%:p:h'))
                local nvim_path = tostring(vim.fn.stdpath('config'))
                local is_neovim = string.find(buffer_path, nvim_path) and true
                    or false
                local is_hammerspoon = string.find(buffer_path, 'hammerspoon')
                        and true
                    or false
                if is_neovim then
                    return 'LuaJIT'
                elseif is_hammerspoon then
                    local lua_version =
                        vim.fn.system('hs -c _VERSION'):gsub('[\n\r]', '')
                    if lua_version:match('^error') then
                        vim.notify(lua_version, vim.log.levels.ERROR, {
                            title = 'Neovim',
                        })
                    end
                    return lua_version
                end
                return 'LuaJIT'
            end

            ---Check if the current repo has a .luarc.json or .luarc.jsonc file
            ---
            ---@return boolean
            -- local function is_luarc_exists(path)
            --     local exists = false
            --     if vim.fn.filereadable(path .. '/.luarc.json') == 1 then
            --         exists = true
            --     elseif vim.fn.filereadable(path .. '/.luarc.jsonc') == 1 then
            --         exists = true
            --     end
            --     return exists
            -- end

            --- On attach function for lua language server
            --- This function is used to set up the `lua` language server
            ---@param client vim.lsp.Client
            local lua_on_attach = function(client, _)
                local root_dir = client.config.root_dir
                    or require('config.utils').get_root_dir()

                local lua_version = get_lua_version()
                local homebrew_prefix =
                    vim.fn.system('brew --prefix'):gsub('[\n\r]', '')

                local lua_path = {
                    '?.lua',
                    '?/init.lua',
                    vim.fn.expand(
                        homebrew_prefix
                            .. '/lib/luarocks/rocks-5.4/luarocks/share/lua/5.4/?.lua'
                    ),
                }

                local user_settings = {
                    Lua = {},
                }
                local lua_client = user_settings.Lua

                lua_client.runtime = {
                    version = lua_version,
                    path = lua_path,
                }
                lua_client.completion = {
                    displayContext = 1,
                }

                lua_client.diagnostics = {
                    enable = true,
                    globals = {
                        'vim',
                        'use',
                        'hs',
                        'describe',
                        'it',
                        'before_each',
                        'after_each',
                    },
                    ['codestyle-check'] = 'Any',
                    libraryFiles = 'Enable',
                }

                local runtime = vim.api.nvim_get_runtime_file('', true)
                local library = {}
                for _, path in ipairs(runtime) do
                    table.insert(library, path .. '/lua')
                end

                lua_client.workspace = {
                    checkThirdParty = true,
                    library = library,
                }
                lua_client.format = {
                    enable = false,
                }
                lua_client.format.defaultConfig = {
                    indent_style = 'space',
                    indent_size = 2,
                }

                -- If current repo is hammerspoon config
                -- Add hammerspoon annotations to the workspace library
                local is_hammerspoon = root_dir:match('hammerspoon')
                if is_hammerspoon then
                    local hammerspoon_path =
                        vim.fn.expand('~/.config/hammerspoon')
                    local annotations_path = hammerspoon_path
                        .. '/Spoons/EmmyLua.spoon/annotations'
                    table.insert(lua_client.workspace.library, annotations_path)
                end

                local settings = vim.tbl_deep_extend(
                    'force',
                    client.config.settings,
                    user_settings
                )
                if not settings then
                    error('Failed to set up `lua language server`')
                end

                client.config.settings = settings
                client.notify('workspace/didChangeConfiguration', {
                    settings = settings,
                })
                client.config.on_attach = on_attach_lsp

                -- Make autogroups for lsp_lua
                vim.api.nvim_create_augroup('LspLua', { clear = true })

                vim.api.nvim_create_autocmd('InsertLeave', {
                    callback = function()
                        local line = vim.api.nvim_win_get_cursor(0)[1]
                        if line ~= vim.b.last_line then
                            vim.cmd('norm! zz')
                            vim.b.last_line = line
                            if vim.fn.getline(line) == '' then
                                local column = vim.fn.getcurpos()[5]
                                vim.fn.cursor({ line, column })
                            end
                        end
                    end,
                    group = 'LspLua',
                    pattern = 'lua',
                })

                return true
            end

            -- Lua
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local lua_ls = {
                on_attach = lua_on_attach,
                handlers = {
                    ['textDocument/publishDiagnostics'] = filter_spoon_diagnostics,
                },
            }
            lspconfig.lua_ls.setup(lua_ls)

            -- Typescript
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local ts_ls = {
                -- settings = {
                --         typescript = ts_ls_config,
                --         javascript = ts_ls_config,
                -- },
                on_init = function(client)
                    local ts_ls_config = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    }
                    client.config.settings =
                        vim.tbl_deep_extend('force', client.config.settings, {
                            typescript = ts_ls_config,
                            javascript = ts_ls_config,
                        })
                    client.notify(
                        'workspace/didChangeConfiguration',
                        { settings = client.config.settings }
                    )
                end,
            }
            -- Configuration to make lsp-inlayhints.nvim work with TypeScript
            lspconfig.ts_ls.setup(ts_ls)

            -- Svelte
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local svelte = {
                -- cmd = { "svelteserver", "--stdio" },
                -- filetypes = { "svelte" },
                -- root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
                -- settings = {},
                -- })
                on_init = function(client)
                    local user_settings = {
                        svelte = {
                            plugin = {
                                html = {
                                    completions = {
                                        enable = true,
                                        emmet = true,
                                    },
                                },
                            },
                        },
                    }
                    client.config.settings = vim.tbl_deep_extend(
                        'force',
                        client.config.settings,
                        user_settings
                    )
                    client.notify(
                        'workspace/didChangeConfiguration',
                        { settings = client.config.settings }
                    )
                end,
            }
            lspconfig.svelte.setup(svelte)

            -- Rust
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local rust_analyzer = {
                on_attach = function(client)
                    local on_attach_opts = function(c, bufnr)
                        require('lsp-format').on_attach(c)
                        vim.api.nvim_create_augroup(
                            'DiagnosicFloat',
                            { clear = true }
                        )
                        vim.api.nvim_create_autocmd('CursorHold', {
                            callback = function()
                                vim.diagnostic.open_float(nil, {})
                            end,
                            group = 'DiagnosicFloat',
                        })
                        vim.keymap.set(
                            'n',
                            '<C-space>',
                            require('rust-tools').hover_actions.hover_actions,
                            { buffer = bufnr }
                        )
                        vim.keymap.set(
                            'n',
                            '<Leader>ga',
                            require('rust-tools').code_action_group.code_action_group,
                            { buffer = bufnr }
                        )
                    end
                    local user_settings = {
                        ['rust-analyzer'] = {
                            on_attach = on_attach_opts,
                            assist = {
                                importMergeBehaviour = 'full', -- this does next: use existing import if possible, otherwise add new import
                            },
                            callInfo = {
                                full = true,
                            },
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                    -- allFeatures = true,
                                },
                                loadOutDirsFromCheck = true,
                            },
                            checkOnSave = {
                                allFeatures = true,
                            },
                            procMacro = {
                                enable = true,
                            },
                            diagnostics = {
                                enable = true,
                                disabled = {
                                    'macro-error',
                                    'unresolved-proc-macro',
                                },
                                enableExperimental = true,
                            },
                        },
                    }
                    client.config.settings = vim.tbl_deep_extend(
                        'force',
                        client.config.settings,
                        user_settings
                    )
                    --         dap = {
                    --                 adapter = {
                    --                         type = "executable",
                    --                         command = "lldb-vscode-10",
                    --                         name = "rt_lldb",
                    --                 },
                    --         },
                    client.notify(
                        'workspace/didChangeConfiguration',
                        { settings = client.config.settings }
                    )
                end,
            }
            lspconfig.rust_analyzer.setup(rust_analyzer)

            -- Python
            -------------------------------------------------------------------------------
            lspconfig.ruff.setup({
                on_attach = require('lsp-format').on_attach,
                init_options = {
                    settings = {
                        -- Any extra CLI arguments for `ruff` go here.
                        args = {},
                        fixAll = true,
                        interpreter = {
                            properties = {
                                InterpreterPath = vim.fn.exepath('python3'),
                                -- InterpreterPath = '/usr/bin/python3',
                                -- InterpreterPath = '/usr/local/bin/python3',
                            },
                        },
                    },
                },
            })

            --- LSP Status
            local lsp_status = require('lsp-status')
            lsp_status.register_progress()
            lsp_status.config = {
                select_symbol = function(cursor_pos, symbol)
                    if symbol.valueRange then
                        local value_range = {
                            ['start'] = {
                                character = 0,
                                line = vim.fn.byte2line(symbol.valueRange[1]),
                            },
                            ['end'] = {
                                character = 0,
                                line = vim.fn.byte2line(symbol.valueRange[2]),
                            },
                        }
                        return require('lsp-status.util').in_range(
                            cursor_pos,
                            value_range
                        )
                    end
                end,
            }

            -- -- local function filter_spoon_diagnostics(err, result, ctx, config)
            -- --         -- Filter out diagnostics from '.*\.spoon/*'
            -- --         local spoon_path_pattern = '^file.*%.spoon.*$'
            -- --         if result.uri:match(spoon_path_pattern) then
            -- --                 if not result.uri:match('^.*init%.lua$') then
            -- --                         return
            -- --                 end
            -- --                 local file_path = require('config.utils')ri_to_fname(result.uri)
            -- --                 if is_my_spoon(file_path) then
            -- --                         return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            -- --                 end
            -- --                 return
            -- --         end
            -- --         return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            -- -- end
            -- --
            -- local function custom_publish_diagnostics(err, result, ctx, config)
            --         local pattern = ".*%.trash/.*"
            --         print("err: ", err)
            --         print("result: ", vim.inspect.inspect(result))
            --         print("ctx: ", vim.inspect.inspect(ctx))
            --         print("config: ", vim.inspect.inspect(config))
            --         P(result)
            --         P(ctx)
            --         if result.uri == type("string") and result.uri:match(pattern) then
            --                 result.diagnostics = vim.tbl_filter(function(diagnostic)
            --                         -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
            --                         return not string.find(diagnostic.source or "", "%.trash/")
            --                 end, result.diagnostics)
            --         end
            --         -- if result.uri:match(pattern) then
            --         --         result.diagnostics = vim.tbl_filter(function(diagnostic)
            --         --                 -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
            --         --                 return not string.find(diagnostic.source or "", "%.trash/")
            --         --         end, result.diagnostics)
            --         -- end
            --
            --         return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            --         --
            --         --         result.diagnostics = vim.tbl_filter(function(diagnostic)
            --         --                 -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
            --         --                 return not string.find(diagnostic.source or "", "%.trash/")
            --         --         end, result.diagnostics)
            --         -- end
            --         -- -- Call the default handler with the filtered diagnostics
            --         -- vim.lsp.diagnostic.on_publish_diagnostics(err, result, { client_id = client_id, bufnr = bufnr }, config)
            -- end

            local function filter_trash_notes(err, result, ctx)
                local pattern = '.*%.trash/.*'
                if result.uri:match(pattern) then
                    result.diagnostics = vim.tbl_filter(function(diagnostic)
                        -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
                        return not string.find(
                            diagnostic.source or '',
                            '%.trash/'
                        )
                    end, result.diagnostics)
                else
                    vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
                end
            end

            lspconfig.marksman.setup({
                on_attach = on_attach_lsp,
                handlers = {
                    ['textDocument/publishDiagnostics'] = filter_trash_notes,
                },
            })

            -- C
            -------------------------------------------------------------------------------
            lspconfig.clangd.setup({
                on_attach = on_attach_lsp,
                handlers = {
                    ['textDocument/publishDiagnostics'] = filter_trash_notes,
                },
            })

            --
            -- if not lsp_configurations.obsidian then
            --         lsp_configurations.obsidian = {
            --                 default_config = {
            --                         autostart = true,
            --                         cmd = { "npx", "obsidian-lsp", "--", "--stdio" },
            --                         single_file_support = false,
            --                         root_dir = require('lspconfig.util').root_pattern('.obsidian'),
            --                         handlers = {
            --                                 --         --- Disable lsp for files in ~/knowledge/\..*/*
            --                                 --         ["textDocument/reference"] = filter_trash_notes,
            --                                 --         ["textDocument/definition"] = filter_trash_notes,
            --                                 --         ["textDocument/documentSymbol"] = filter_trash_notes,
            --                                 --         ["textDocument/hover"] = filter_trash_notes,
            --                                 ["workspace/diagnostics"] = vim.lsp.with(
            --                                         filter_trash_notes, {}),
            --                         },
            --                 },
            --         }
            -- end
            -- lspconfig.obsidian.setup {}

            -- ctags
            require('lspconfig').ctags_lsp.setup({})

            --

            -- Autocommands
            lsp_zero.on_attach(on_attach_lsp)
        end,
        branch = 'v3.x',
    },
}
