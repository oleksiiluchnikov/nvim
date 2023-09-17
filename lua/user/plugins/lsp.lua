vim.opt.signcolumn = 'yes'

local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
local cmp = require('cmp')
local luasnip = require('luasnip')

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
lsp.preset('recommended')


-- Ensure installation of the recommended LSP servers
lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer',
    'lua_ls',
})


lsp.skip_server_setup({ 'rust_analyzer' })

lsp.on_attach(function(client, bufnr)
    --------------------------------------------------------------------------
    -- Mappings.
    --------------------------------------------------------------------------
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<space>f', function()
                vim.lsp.buf.format { async = true } --
                -- Enable formatting on save or leaving insert mode if LSP is attached, with formatting capabilities
                autocmd('BufWritePre', '*', 'lua vim.lsp.buf.formatting_sync(nil, 1000)')
            end, opts)

            ------------------------------------------------------------------------------
        end,
    })
end)

lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})
-- Configure diagnostic settings
vim.diagnostic.config({
    underline = true,         -- show underline diagnostics (default: true)
    update_in_insert = false, -- update diagnostics insert mode (default: false)
    severity_sort = true,     -- sort diagnostics by severity (default: false)
    float = {
        border = "single",    -- border style (default: "single")
        source = "always",    -- show source (default: "always")
        format = "markdown",  -- format of the output (default: "markdown")
        width = 80,           -- width of the output (default: 80)
        height = 20,          -- height of the output (default: 20)
        focusable = false,    -- focusable (default: false)
        wrap = "truncate",    -- wrap mode (default: "truncate")
    },
    virtual_text = {
        prefix = "▶", -- prefix for virtual text diagnostics
        spacing = 8,  -- spacing to the left of a virtual text diagnostic (default: 4)
    },
    signs = {
        severity_limit = "Error", -- severity limit (default: "Error")
    },
})
------------------------------------------------------------------------------
-- LSP inlay hints
if vim.fn.has('nvim-0.8') == 1 then
    local lsp_augroup = augroup('LSP_preferences', { clear = true })
    autocmd('LspAttach', {
        group = lsp_augroup,
        callback = function(args)
            if not (args.data and args.data.client_id) then
                return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            require('lsp-inlayhints').on_attach(client, bufnr)
            if client.server_capabilities.codeLensProvider then
                autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                    group = lsp_augroup,
                    buffer = bufnr,
                    callback = vim.lsp.codelens.refresh,
                })
            end
        end,
    })
end

------------------------------------------------------------------------------
-- Format code on leaving insert mode and after saving a file
-- Setup LSP servers
------------------------------------------------------------------------------
-- Lua
------------------------------------------------------------------------------
local hs_version = vim.fn.system('hs -c _VERSION'):gsub('\n\r', '')
local hs_path = vim.split(vim.fn.system('hs -c package.path'):gsub('[\n\r]', ''), ';')

lsp.configure('lua_ls', {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            runtime = {
                version = hs_version,
                path = hs_path,
            },
            diagnostics = {
                globals = { "vim", "use", "hs" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    string.format('%s/.config/hammerspoon/Spoons/EmmyLua.spoon/annotations', os.getenv('HOME')),
                },
            },
        },
    },
    on_attach = function(client, bufnr)
        require('user.functions.formatting.lua')
    end,
})

------------------------------------------------------------------------------
-- Typescript
------------------------------------------------------------------------------
-- Configuration to make lsp-inlayhints.nvim work with TypeScript
local tsserver_config = {
    inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
    }
}
lsp.configure('tsserver', {
    settings = {
        typescript = tsserver_config,
        javascript = tsserver_config,
    },
})

------------------------------------------------------------------------------
-- Svelte
------------------------------------------------------------------------------
lsp.configure('svelte', {
    cmd = { "svelteserver", "--stdio" },
    filetypes = { "svelte" },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    settings = {},
})

lsp.setup {}
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Rust
------------------------------------------------------------------------------
local rust_lsp_on_attach = function(_, bufnr)
    vim.api.nvim_create_augroup('DiagnosicFloat', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
            vim.diagnostic.open_float(nil, {
                border = 'rounded',
                source = 'always',
                focusable = false,
                wrap = 'truncate',
                width = 80,
                height = 20,
            })
        end,
        group = 'DiagnosicFloat',
    })
    vim.keymap.set("n", "<C-space>", require('rust-tools').hover_actions.hover_actions, { buffer = bufnr })
    vim.keymap.set("n", "<Leader>ga", require('rust-tools').code_action_group.code_action_group, { buffer = bufnr })
end

require('lsp-inlayhints').setup {}

if vim.fn.has('nvim-0.8') == 1 then
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
end


require('rust-tools').setup({
 server = {
    on_attach = rust_lsp_on_attach,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importMergeBehaviour = "full", -- this does next: use existing import if possible, otherwise add new import
        },

        callInfo = {
          full = true,
        },

        cargo = {
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
            "unresolved-proc-macro",
          },
          enableExperimental = true,
          warningsAsHint = {},
        },
      },
    },
  },

  dap = {
    adapter = {
      type = "executable",
      command = "lldb-vscode-10",
      name = "rt_lldb",
    },
  },
})

-- Disable diagnostics for rust-analyzer
-- like proc-macro not expanded
------------------------------------------------------------------------------
-- Mappings
------------------------------------------------------------------------------

-- [[ Copilot ]]
------------------------------------------------------------------------------

-- Confirm Complition with C-y(es) in insert mode
vim.keymap.set('i', '<C-y>', function(fallback)
    local copilot = require('copilot.suggestion')
    if copilot.is_visible() then
        copilot.accept_word()
    elseif cmp.visible() then
        cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = select })()
    elseif luasnip.expandable() then
        luasnip.expand()
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'confirm completion with C-y(es)'
})

-- Accept line
vim.keymap.set('i', '<C-c>',
    function()
        local copilot = require('copilot.suggestion')
        if copilot.is_visible() then
            copilot.accept_line()
        end
    end,
    {
        silent = true,
        desc = 'copilot: accept line',
    }
)

-- Accept whole copilot suggestion
vim.keymap.set('i', '<C-j>',
    function()
        local copilot = require('copilot.suggestion')
        if copilot.is_visible() then
            copilot.accept()
        end
    end,
    {
        silent = true,
        desc = 'copilot: accept whole suggestion',
    })

------------------------------------------------------------------------------
-- Command mode
------------------------------------------------------------------------------

-- Confirm Complition with C-y(es) in command mode
vim.keymap.set('c', '<C-y>', function()
    if cmp.visible() then
        cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = select })()
    end
end, {
    silent = true,
    desc = 'confirm completion with C-y(es)'
})

vim.keymap.set('!', '<C-y>', function()
    if cmp.visible() then
        cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = select })()
    end
end, {
    silent = true,
    desc = 'confirm completion with C-y(es)'
})

-- Select Next Item with C-n(ext)
vim.keymap.set('i', '<C-n>', function(fallback)
    if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").next()
    elseif cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expandable() then
        luasnip.jump(1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'select next item with C-n(ext)'
})

vim.keymap.set('c', '<C-n>', function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expandable() then
        luasnip.jump(1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'select next item with C-n(ext)'
})

vim.keymap.set('!', '<C-n>', function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expandable() then
        luasnip.jump(1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'select next item with C-n(ext)'
})

-- Select Previous Item with C-p(revious)
vim.keymap.set('i', '<C-p>', function(fallback)
    if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").prev()
    elseif cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'select previous item with C-p(revious)'
})

vim.keymap.set('!', '<C-p>', function(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.expandable() then
        luasnip.jump(-1)
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'select next item with C-n(ext)'
})



-- Scroll documentation / diagnostic preview C-u(p)
vim.keymap.set('i', '<C-u>', function(fallback)
    if cmp.visible() then
        cmp.scroll_docs(-4)
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'scroll documentation / diagnostic preview up in insert mode'
})

-- Scroll documentation / diagnostic preview C-d(own)
vim.keymap.set('i', '<C-d>', function(fallback)
    if cmp.visible() then
        cmp.scroll_docs(4)
    else
        fallback()
    end
end, {
    silent = true,
    desc = 'scroll documentation / diagnostic preview down in insert mode'
})
