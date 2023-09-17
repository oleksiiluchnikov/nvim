--- Get the source lines of a Lua function.
local path
---
--- @param func function The function whose source lines are to be retrieved.
--- @return table<string>|nil The source lines of the function.
local function get_function_source(func)
    local info = debug.getinfo(func, "S") -- @table info
    if info.source:sub(1, 1) == "@" then
        path = info.source:sub(2)
    end
    if path == nil then
        return nil
    end
    local range = { info.linedefined, info.lastlinedefined }
    local f = assert(io.open(path, "rb"))
    -- get lines from the file
    local first_line
    local line_num = 0
    for line in f:lines() do
        line_num = line_num + 1
        if line_num == range[1] then
            first_line = line
            break
        end
    end
    f:close()
    local tbl = {}
    tbl.first_line = first_line
    tbl.path = path
    tbl.func_name = first_line:match("function%s+(%w+)") or 
                    first_line:match("local%s+(%w+)") or
                    first_line:match("(%w+)%s*=")
    tbl.path_to_parent = path:match("(.*/)")
    return tbl
end
--P(get_function_source)

--- Print the inspected value of a variable using a notification window
--- @param v any Value to inspect and print
--- @return any Returns the same value that was passed as an argument
P = function(v)
    local title = 'Type: ' .. type(v)
    local text

    if type(v) == 'function' then
        local tbl = get_function_source(v)
        require('telescope.builtin').live_grep({
            default_text = tbl.func_name,
            search_dirs = { tbl.path_to_parent },
        })
    elseif type(v) == 'table' then
        text = vim.inspect(v)

        vim.notify(text, vim.log.levels.INFO, {
            title = title,
            on_open = function(win)
                local buf = vim.api.nvim_win_get_buf(win)
                vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')
            end
        })
        return v
    end
    return nil
end

--- Log a message using a notification window with an INFO log level
--- @param msg string|nil
LOG = function(msg)
    if type(msg) == 'string' then
        vim.notify(msg, vim.log.levels.INFO, {
        title = 'LOG',
        })
        return
    elseif type(msg) == 'table' then
        msg = vim.inspect(msg)
        return
    elseif type(msg) == nil then
        vim.notify('nil', vim.log.levels.INFO, {
            title = 'LOG',
        })
        return nil
    end
end

--- Log an error message using a notification window with an ERROR log level
--- @param msg string Error message to log
ERROR = function(msg)
    vim.notify(msg, vim.log.levels.ERROR, {
        title = 'ERROR',
    })
end

--- Create a user command 'P' that is an alias for the P function
vim.api.nvim_create_user_command(
    'P', 'lua P(<args>)', {
        nargs = '*',
        complete = 'customlist,v:lua.vim.lsp.omnifunc',
    }
)


--
function TODO(str)
    -- Get the function name of the calling function
    if str == nil then
        str = ''
    end
    local response = {}
    local info = debug.getinfo(2, "nSl")
    response.source = info.short_src
    local path = info.source:sub(2)
    -- respons '...ov/nvim/lua/user/constants.lua' so we need to remove the first 6 characters
    response.func_name = info.name
    response.func_line = info.linedefined
    response.func_last_line = info.lastlinedefined
    response.func_line_count = response.func_last_line - response.func_line
    response.path_to_parent = info.source:match("(/.*/)")
    if pcall(require, 'telescope') then
        require('telescope.builtin').live_grep({
            default_text = response.func_name,
            search_dirs = { response.path_to_parent },
            prompt_title = 'TODO',
            glob_pattern = { '*.lua' },
        })
    else
        vim.notify('Look for TODOs in ' .. response.source, vim.log.levels.INFO, {
            title = 'TODO',
        })
    end
    vim.notify('TODO: ' .. str, vim.log.levels.INFO, {
        title = 'TODO',
    })
end
