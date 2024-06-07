local lsp_zero = require("lsp-zero") -- LSP Zero plugin
lsp_zero.extend_lspconfig()
local mason = require("mason")
local lspconfig = require("lspconfig")

---@type fun(client: lsp.Client, bufnr: number)
local on_attach = require("user.plugins.lsp.on_attach")

vim.opt.signcolumn = "yes"

mason.setup()
require("mason-lspconfig").setup()

-- lsp_zero.skip_server_setup({ 'rust_analyzer' })
lsp_zero.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = "E",
        warn = "W",
        hint = "H",
        info = "I",
    },
})

-- Bash, Shell, zsh etc
------------------------------------------------------------------------------
lspconfig.bashls.setup({
    on_attach = on_attach,
    cmd = { "bash-language-server", "start" },
    cmd_env = {
        GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)",
    },
    filetypes = { "sh", "zsh", "bash", "shell" },
})

--- Check if spoon is mine by checking author field in init.lua
---
---@return boolean
local function is_my_spoon(file_path)
    local function check_pattern(pattern)
        local command = { "grep", "-q", "-E", pattern, file_path }
        return vim.fn.systemlist(command)
    end

    local username = vim.fn.system("whoami"):gsub("[\n\r]", "")
    local fullname = vim.fn.system("git config --get user.name"):gsub("[\n\r]", "")
    local email = vim.fn.system("git config --get user.email"):gsub("[\n\r]", "")

    -- Check for author
    for _, identifier in ipairs({ username, fullname, email }) do
        local pattern = "^\\w+\\.author\\s*=\\s*.*" .. identifier .. ".*"
        if #check_pattern(pattern) > 0 then
            return true -- Authored by you
        end
    end

    -- If the spoonPath contains your username, it's likely not authored by you.
    local exclude_pattern = "spoonPath = \".*" .. username .. ".*\""
    if #check_pattern(exclude_pattern) > 0 then
        return false -- Contains specific spoonPath, but not authored by you.
    end

    return false -- Default to not yours if no matching conditions.
end

--- Filter out diagnostics from spoons that are not authored by me.
local function filter_spoon_diagnostics(err, result, ctx, config)
    -- Filter out diagnostics from '.*\.spoon/*'
    local spoon_path_pattern = "^file.*%.spoon.*$"
    if result.uri:match(spoon_path_pattern) then
        if not result.uri:match("^.*init%.lua$") then
            return
        end
        local file_path = vim.uri_to_fname(result.uri)
        if is_my_spoon(file_path) then
            return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
        end
        return
    end
    return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
end

--- Get the lua version of the current buffer
---
---@return string
local function get_lua_version()
    local buffer_path = tostring(vim.fn.expand("%:p:h"))
    local nvim_path = tostring(vim.fn.stdpath("config"))
    local is_neovim = string.find(buffer_path, nvim_path) and true or false
    local is_hammerspoon = string.find(buffer_path, "hammerspoon") and true or false
    if is_neovim then
        return "LuaJIT"
    elseif is_hammerspoon then
        local lua_version = vim.fn.system("hs -c _VERSION"):gsub("[\n\r]", "")
        if lua_version:match("^error") then
            vim.notify(lua_version, vim.log.levels.ERROR, {
                title = "Neovim",
            })
        end
        return lua_version
    end
    return "LuaJIT"
end

---Check if the current repo has a .luarc.json or .luarc.jsonc file
---
---@return boolean
local function is_luarc_exists(path)
    local exists = false
    if vim.fn.filereadable(path .. "/.luarc.json") == 1 then
        exists = true
    elseif vim.fn.filereadable(path .. "/.luarc.jsonc") == 1 then
        exists = true
    end
    return exists
end

--- On attach function for lua language server
--- This function is used to set up the `lua` language server
---@param client lsp.Client
local lua_on_attach = function(client, _)
    -- ih.on_attach(client, bufnr)

    local root_dir = client.config.root_dir

    -- if is_luarc_exists(root_dir) then
    --     return true
    -- end

    local lua_version = get_lua_version()
    local homebrew_prefix = vim.fn.system("brew --prefix"):gsub("[\n\r]", "")

    local lua_path = {
        "?.lua",
        "?/init.lua",
        vim.fn.expand(homebrew_prefix .. "/lib/luarocks/rocks-5.4/luarocks/share/lua/5.4/?.lua"),
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
            "vim",
            "use",
            "hs",
            "describe",
            "it",
            "before_each",
            "after_each",
        },
        ["codestyle-check"] = "Any",
        libraryFiles = "Enable",
    }

    local runtime = vim.api.nvim_get_runtime_file("", true)
    local library = {}
    for _, path in ipairs(runtime) do
        table.insert(library, path .. "/lua")
    end

    lua_client.workspace = {
        checkThirdParty = true,
        library = library,
    }
    lua_client.format = {
        enable = false,
    }
    lua_client.format.defaultConfig = {
        indent_style = "space",
        indent_size = 4,
    }

    -- If current repo is hammerspoon config
    -- Add hammerspoon annotations to the workspace library
    local is_hammerspoon = root_dir:match("hammerspoon")
    if is_hammerspoon then
        local hammerspoon_path = vim.fn.expand("~/.config/hammerspoon")
        local annotations_path = hammerspoon_path .. "/Spoons/EmmyLua.spoon/annotations"
        table.insert(lua_client.workspace.library, annotations_path)
    end

    local settings = vim.tbl_deep_extend("force", client.config.settings, user_settings)
    if not settings then
        error("Failed to set up `lua language server`")
    end

    client.config.settings = settings
    client.notify("workspace/didChangeConfiguration", {
        settings = settings,
    })
    client.config.on_attach = on_attach

    -- Make autogroups for lsp_lua
    vim.api.nvim_create_augroup("LspLua", { clear = true })

    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            local line = vim.api.nvim_win_get_cursor(0)[1]
            if line ~= vim.b.last_line then
                vim.cmd("norm! zz")
                vim.b.last_line = line
                if vim.fn.getline(line) == "" then
                    local column = vim.fn.getcurpos()[5]
                    vim.fn.cursor({ line, column })
                end
            end
        end,
        group = "LspLua",
        pattern = "lua",
    })

    return true
end

-- Lua
------------------------------------------------------------------------------
---@type lsp.Client
local lua_client = {
    on_attach = lua_on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = filter_spoon_diagnostics,
    },
}
lspconfig.lua_ls.setup(lua_client)

-- Typescript
------------------------------------------------------------------------------
-- Configuration to make lsp-inlayhints.nvim work with TypeScript
lspconfig.tsserver.setup({
    -- settings = {
    --         typescript = tsserver_config,
    --         javascript = tsserver_config,
    -- },
    on_init = function(client)
        local tsserver_config = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        }
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
            typescript = tsserver_config,
            javascript = tsserver_config,
        })
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end,
})

-- Svelte
------------------------------------------------------------------------------
lspconfig.svelte.setup({
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
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, user_settings)
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end,
})

------------------------------------------------------------------------------
-- Rust
------------------------------------------------------------------------------
---
--[[
augroup('LSP_preferences', { clear = true })
autocmd('LspAttach', {
        group = 'LSP_preferences',
        -- callback = function(args)
        --     if not (args.data and args.data.client_id) then
        --         return
        --     end
        --
        --     local bufnr = args.buf
        --     local client = vim.lsp.get_client_by_id(args.data.client_id)
        --
        --     require('lsp-inlayhints').on_attach(client, bufnr)
        --     if client.server_capabilities.codeLensProvider then
        --         autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        --             group = 'LSP_preferences',
        --             buffer = bufnr,
        --             callback = vim.lsp.codelens.refresh,
        --         })
        --     end
        -- end, like this but disable for rust
        callback = function(args)
                if not (args.data and args.data.client_id) then
                        return
                end
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then
                        return
                end
                if client.name ~= 'rust_analyzer' then
                        require('lsp-inlayhints').on_attach(client, bufnr)
                end
                if client.server_capabilities.codeLensProvider then
                        autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                                group = 'LSP_preferences',
                                buffer = bufnr,
                                callback = vim.lsp.codelens.refresh,
                        })
                end
        end,
})
--]]

lspconfig.rust_analyzer.setup({
    on_attach = function(client)
        local on_attach_opts = function(c, bufnr)
            require("lsp-format").on_attach(c)
            vim.api.nvim_create_augroup("DiagnosicFloat", { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = function()
                    vim.diagnostic.open_float(nil, {})
                end,
                group = "DiagnosicFloat",
            })
            vim.keymap.set(
                "n",
                "<C-space>",
                require("rust-tools").hover_actions.hover_actions,
                { buffer = bufnr }
            )
            vim.keymap.set(
                "n",
                "<Leader>ga",
                require("rust-tools").code_action_group.code_action_group,
                { buffer = bufnr }
            )
        end
        local user_settings = {
            ["rust-analyzer"] = {
                on_attach = on_attach_opts,
                assist = {
                    importMergeBehaviour = "full", -- this does next: use existing import if possible, otherwise add new import
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
                        "macro-error",
                        "unresolved-proc-macro",
                    },
                    enableExperimental = true,
                },
            },
        }
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, user_settings)
        --         dap = {
        --                 adapter = {
        --                         type = "executable",
        --                         command = "lldb-vscode-10",
        --                         name = "rt_lldb",
        --                 },
        --         },
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end,
})

-- Python
------------------------------------------------------------------------------
lspconfig.ruff_lsp.setup({
    on_attach = require("lsp-format").on_attach,
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
            fixAll = true,
            interpreter = {
                properties = {
                    InterpreterPath = vim.fn.exepath("python3"),
                    -- InterpreterPath = '/usr/bin/python3',
                    -- InterpreterPath = '/usr/local/bin/python3',
                },
            },
        },
    },
})

lsp_zero.default_setup(require("mason-lspconfig").get_available_servers())

--- LSP Status
local lsp_status = require("lsp-status")
lsp_status.register_progress()
lsp_status.config = {
    select_symbol = function(cursor_pos, symbol)
        if symbol.valueRange then
            local value_range = {
                ["start"] = {
                    character = 0,
                    line = vim.fn.byte2line(symbol.valueRange[1]),
                },
                ["end"] = {
                    character = 0,
                    line = vim.fn.byte2line(symbol.valueRange[2]),
                },
            }
            return require("lsp-status.util").in_range(cursor_pos, value_range)
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
-- --                 local file_path = vim.uri_to_fname(result.uri)
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

local function filter_trash_notes(err, result, ctx, config)
    local pattern = ".*%.trash/.*"
    if result.uri:match(pattern) then
        result.diagnostics = vim.tbl_filter(function(diagnostic)
            -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
            return not string.find(diagnostic.source or "", "%.trash/")
        end, result.diagnostics)
    else
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
    end
end

lspconfig.marksman.setup({
    on_attach = on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = filter_trash_notes,
    },
})

-- C
------------------------------------------------------------------------------
lspconfig.clangd.setup({
    on_attach = on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = filter_trash_notes,
    },
})

-- C++

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

vim.defer_fn(function()
    require("user.plugins.lsp.diagnostics")
    require("user.plugins.lsp.lsp-format")
end, 500)

-- Autocommands
lsp_zero.on_attach(on_attach)
