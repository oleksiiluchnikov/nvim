--- @type table
require('config.utils').git = {}

--- Sets up global git base variable to HEAD ref
---
--- @return nil
require('config.utils').git.setup = function()
    vim.g.git_base = 'HEAD'
end

--- Checks if the current directory is a git repository
---
--- @return boolean
require('config.utils').git.is_repo = function()
    vim.fn.system('git -C . rev-parse')
    return vim.v.shell_error == 0
end

--- Get the root directory of the current git repo
--- @return string? root_dir
function require('config.utils').git.get_root_dir()
    if not require('config.utils').git.is_repo() then
        return nil
    end

    local output = vim.fn.system('git rev-parse --show-toplevel')
    local root_dir = vim.trim(output)
    if root_dir == '' then
        return nil
    end
    return root_dir
end

--- Sets the git base ref for diffing
---
--- @param base string? The git ref to diff against, defaults to HEAD
function require('config.utils').git.set_diff_base(base)
    if not base or base == '' then
        base = 'HEAD'
    end

    vim.g.git_base = base

    vim.g.gitgutter_diff_base = vim.g.git_base

    local win = vim.api.nvim_get_current_win()
    vim.cmd([[noautocmd windo GitGutter]])
    vim.api.nvim_set_current_win(win)

    print(string.format('Now diffing against %s', vim.g.git_base))
end
