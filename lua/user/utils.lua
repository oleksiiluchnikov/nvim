local utils = {}

--- Get the project root directory of the current file or the given path.
---@param path Optional path to search, defaults to current file
---@return string
function utils.get_root_dir(path)
    path = path or vim.fn.expand("%:p:h")

    local root_dir

    -- Try to find root with lspconfig
    if pcall(require, "lspconfig") then
        root_dir = vim.lsp.buf.list_workspace_folders()[1]
        if root_dir then
            return root_dir
        end
    end

    -- Fallback to custom git root search
    root_dir = require("user.git").get_root_dir()
    if root_dir then
        return root_dir
    end

    -- Default to current working dir
    return vim.fn.getcwd()
end

---Get the current visual selection.
---@return string
function utils.get_visual_selection()
    local _, ls, cs = unpack(vim.fn.getpos("v")) -- start of visual selection
    local _, le, ce = unpack(vim.fn.getpos(".")) -- end of visual selection
    local range_text = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
    local selection = table.concat(range_text, "\n")
    return selection
end

---Get the source of a function that is passed in.
---@param func function
---@return table|nil
function utils.get_function_source(func)
    local info = debug.getinfo(func, "S")
    if not info.source or info.source:sub(1, 1) ~= "@" then
        return nil
    end

    local path = info.source:sub(2)
    local f = assert(io.open(path, "rb"))
    local first_line
    local line_num = 0
    for line in f:lines() do
        line_num = line_num + 1
        if line_num == info.linedefined then
            first_line = line
            break
        end
    end
    f:close()

    if not first_line then
        return nil
    end

    local tbl = {
        first_line = first_line,
        path = path,
        func_name = first_line:match("function%s+(%w+)")
            or first_line:match("local%s+(%w+)")
            or first_line:match("(%w+)%s*="),
        path_to_parent = path:match("(.*/)"),
    }
    return tbl
end

--- Jump to next line with same indentation level
--- @param down boolean
--- @param ignore string[]
--- @return boolean
function utils.jump_to_next_line_with_same_indent(down, ignore)
    local line_num = vim.fn.line(".")
    local max_lines = vim.fn.line("$")
    local target_indent

    local ignore_set = {}
    for _, v in ipairs(ignore) do
        ignore_set[v] = true
    end

    ---@param line_content string
    ---@return number
    local function get_indentation_level(line_content)
        local spaces = line_content:match("^(%s*)")
        return #spaces
    end

    ---@param line_content string
    ---@return boolean
    local function starts_with_ignore(line_content)
        for pattern in pairs(ignore_set) do
            if line_content:match("^%s*" .. pattern .. "%S*") then
                return true
            end
        end
        return false
    end

    local curr_line_content = vim.fn.getline(line_num)

    -- If the current line is empty, try to find the next non-empty line's indentation as the target_indent
    if curr_line_content:match("^%s*$") then
        local temp_line_num = down and (line_num + 1) or (line_num - 1)
        while
            temp_line_num > 0
            and temp_line_num <= max_lines
            and vim.fn.getline(temp_line_num):match("^%s*$")
        do
            temp_line_num = down and (temp_line_num + 1) or (temp_line_num - 1)
        end
        if temp_line_num <= 0 or temp_line_num > max_lines then
            return true -- Reached the top or bottom without finding a non-empty line
        end
        curr_line_content = vim.fn.getline(temp_line_num)
        line_num = temp_line_num
    end

    local first_char_pos = curr_line_content:find("[A-Za-z_]")
    if first_char_pos then
        target_indent = get_indentation_level(curr_line_content)
    else
        return true -- No valid indentation level found in current line
    end

    -- Define the direction for the loop increment
    local increment = down and 1 or -1

    -- Start searching from the next/previous line
    line_num = line_num + increment

    while (not down and line_num > 0) or (down and line_num <= max_lines) do
        local line_content = vim.fn.getline(line_num)
        local new_first_char_pos = line_content:find("[A-Za-z_]")
        if new_first_char_pos then
            local current_indent = get_indentation_level(line_content)
            if current_indent == target_indent and not starts_with_ignore(line_content) then
                vim.api.nvim_win_set_cursor(0, { line_num, new_first_char_pos - 1 })
                break
            end
        end
        line_num = line_num + increment
    end

    return true
end

---Pretty print a result. If table, print the table in a floating window.
function P(v)
    local title = "Type: " .. type(v)
    local text

    if type(v) == "function" then
        local tbl = utils.get_function_source(v)

        if not tbl then
            vim.notify("Could not get function source", vim.log.levels.ERROR, {
                title = "ERROR",
            })
            return nil
        end
        require("telescope.builtin").live_grep({
            default_text = tbl.func_name,
            search_dirs = { tbl.path_to_parent },
        })
    else
        -- Pretty print the table in a floating window
        text = vim.inspect(v)

        local buf = vim.api.nvim_create_buf(false, true)

        local bufheight = vim.api.nvim_get_option("lines")
        local bufwidth = vim.api.nvim_get_option("columns")

        local winheight = math.ceil(bufheight * 0.8 - 4)
        local winwidth = math.ceil(bufwidth * 0.8)

        local row = math.ceil((bufheight - winheight) / 2 - 2)

        local col = math.ceil((bufwidth - winwidth) / 2)

        local opts = {
            relative = "editor",
            width = winwidth,
            height = winheight,
            row = row,
            col = col,
            style = "minimal",
            border = "rounded",
        }

        local win = vim.api.nvim_open_win(buf, true, opts)
        vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
        vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(text, "\n"))
        vim.api.nvim_buf_set_option(buf, "filetype", "lua")
        -- Turn on numbers
        vim.api.nvim_win_set_option(win, "number", true)

        -- attach mappings to the window and detach when closed
        vim.keymap.set("n", "q", function()
            vim.api.nvim_win_close(win, true)
        end, { nowait = true, buffer = buf })

        vim.keymap.set("n", "<esc>", function()
            vim.api.nvim_win_close(win, true)
        end, { nowait = true, buffer = buf })

        return v
    end
    return nil
end

function R(_package)
    package.loaded[_package] = nil
    return require(_package)
end

function T()
    print(require("nvim-treesitter.ts_utils").get_node_at_cursor():type())
end

return utils
--[[
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

ERROR = function(msg)
        vim.notify(msg, vim.log.levels.ERROR, {
                title = 'ERROR',
        })
end

vim.api.nvim_create_user_command(
        'P', 'lua P(<args>)', {
                nargs = '*',
                complete = 'customlist,v:lua.vim.lsp.omnifunc',
        }
)


function TODO(str)
        if str == nil then
                str = ''
        end
        local response = {}
        local info = debug.getinfo(2, "nSl")
        response.source = info.short_src
        local path = info.source:sub(2)
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
--]]
