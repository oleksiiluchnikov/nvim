return function(client, bufnr)
    -- require("lsp-format").on_attach(client)
    if client.supports_method("textDocument/inlayHint") then
        require("lsp-inlayhints").on_attach(client, bufnr)
    end
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set(
        "n",
        "<leader>e",
        vim.diagnostic.open_float,
        { desc = "open diagnostics in float window", noremap = true }
    )
    vim.keymap.set("n", "[d", function()
        -- Check if Trouble is toggled
        if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
        else
            vim.diagnostic.goto_prev({ popup_opts = { border = "rounded" } })
        end
    end, { desc = "go to previous diagnostic", noremap = true })

    vim.keymap.set("n", "]d", function()
        -- require('trouble').previous({ skip_groups = true, jump = true })
        if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
        else
            vim.diagnostic.goto_next({ popup_opts = { border = "rounded" } })
        end
    end, { desc = "go to next diagnostic", noremap = true })
    vim.keymap.set(
        "n",
        "<leader>q",
        vim.diagnostic.setloclist,
        { desc = "set loclist", noremap = true }
    )

    vim.keymap.set("n", "<leader>gd", function()
        local current_repo_path = client.config.root_dir
        vim.cmd("cd " .. current_repo_path)
        local current_search
        local ts_node = vim.treesitter.get_node()
        if ts_node then
            current_search = vim.treesitter.get_node_text(ts_node, vim.fn.bufnr())
            if current_search == "" then
                current_search = vim.fn.expand("<cword>")
            end
        else
            current_search = vim.fn.expand("<cword>")
        end
        if type(current_search) == "string" then
            if string.find(current_search, "\n") then
                return
            end
        end
        require("telescope.builtin").grep_string({ -- use current word under cursor as query
            search_dirs = {
                current_repo_path,
            },
            word_match = "-w",
            default_text = current_search,
            path_display = { "truncate" },
        })
    end, { desc = "find definitions", noremap = true })
    vim.keymap.set("v", "<leader>gd", function()
        local current_repo_path =
            require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p:h"))
        vim.cmd("cd " .. current_repo_path)
        local current_search = vim.fn.getreg("g")
        require("telescope.builtin").grep_string({ -- use current word under cursor as query
            search_dirs = {
                current_repo_path,
            },
            default_text = current_search,
            word_match = "-w",
            path_display = { "smart" },
            initial_mode = "normal",
        })
    end, { desc = "find definitions", noremap = true })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", function()
        -- cd to current file's directory until .git is found
        require("telescope.builtin").lsp_references({
            -- use current word under cursor as query
            default_text = vim.fn.expand("<cword>"),
        })
    end, { desc = "find references", noremap = true })
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end
