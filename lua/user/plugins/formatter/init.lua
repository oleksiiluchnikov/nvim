local util = require("formatter.util")
local formatter = require("formatter")
local default_opts = {
    logging = false,
    log_level = vim.log.levels.WARN,
    filetype = {
        lua = {
            require("formatter.filetypes.lua").stylua,
            function()
                -- Supports conditional formatting
                if util.get_current_buffer_file_name() == "special.lua" then
                    return nil
                end

                return {
                    exe = "stylua",
                    args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },
        python = {
            require("formatter.filetypes.python").black,
            function()
                return {
                    exe = "black",
                    args = { "-" },
                    stdin = true,
                }
            end,
        },
        markdown = {
            function(parser)
                if not parser then
                    return {
                        exe = "prettier",
                        args = {
                            "--stdin-filepath",
                            util.escape_path(util.get_current_buffer_file_path()),
                        },
                        stdin = true,
                        try_node_modules = true,
                    }
                end

                return {
                    exe = "prettier",
                    args = {
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--parser",
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
                    exe = "rustfmt",
                    args = {
                        "--emit=stdout",
                        "--edition=2021",
                    },
                    stdin = true,
                }
            end,
        },

        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
}

-- Automatically run formatter on buffer write
vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = "FormatAutogroup",
    pattern = "*",
    callback = function()
        vim.lsp.buf.format()
    end,
})

formatter.setup(default_opts)

local augroup_formatter = vim.api.nvim_create_augroup("__formatter__", {
    clear = true,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    -- command = "FormatWrite",
    callback = function()
        vim.cmd("FormatWrite")
    end,
    group = augroup_formatter,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*.lua",
    command = "Format",
    group = augroup_formatter,
})
