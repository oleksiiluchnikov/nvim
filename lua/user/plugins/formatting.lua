local M
function M.format()
    -- Autoformat on save or leaving insert mode if LSP is attached, with formatting capabilities
    vim.cmd('lua vim.lsp.buf.formatting_sync(nil, 1000)')
end
return M
