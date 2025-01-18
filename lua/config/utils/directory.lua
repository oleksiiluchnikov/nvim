
local M = {}
--- Get the project root directory of the current file or the given path.
--- ```lua
--- local root_dir = require('config.utils').get_root_dir()
--- assert(root_dir:match('^%w+://'))
--- ```
--- @param path? string Optional path to search, defaults to current file
--- @return string
function M.get_root_dir(path)
    path = path or vim.fn.expand('%:p:h')

    -- Try to find root with lspconfig
    local root_dir = vim.lsp.buf.list_workspace_folders()[1]
    if root_dir then
        return root_dir
    end

    -- Fallback to custom git root search
    root_dir = require('config.utils').git.get_root_dir()
    if root_dir then
        return root_dir
    end

    -- Default to current working dir
    return vim.fn.getcwd()
end
return M
