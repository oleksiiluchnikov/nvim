local M = {}

local function convert_lines(lines, from_pattern, to_format)
    local new_lines = {}
    for _, line in ipairs(lines) do
        if string.match(line, from_pattern) then
            local func_name, args = string.match(line, from_pattern)
            local new_line = string.format(to_format, func_name, args)
            table.insert(new_lines, new_line)
        else
            table.insert(new_lines, line)
        end
    end
    return new_lines
end

--- Converts local module functions to public functions
--- @param buf number Buffer handle
--- @param start_line integer Start line
--- @param end_line integer End line
--- @return string[] Modified lines
function M.function_from_local_to_public(buf, start_line, end_line)
    --- @type string[]
    local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)

    --- @type string
    local pattern = "^function M%.([a-zA-Z0-9_]+)%((.*)%)$"

    --- @type string
    local to_format = "M.%s = function(%s)"

    --- @type string[]
    local new_lines = convert_lines(lines, pattern, to_format)

    vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, new_lines)

    --- @type string[]
    return new_lines
end

function M.function_from_public_to_local(buf, start_line, end_line)
    local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
    local pattern = "^M%.([a-zA-Z0-9_]+) = function(%(.*%)$"
    local to_format = "function M.%s(%s)"
    local new_lines = convert_lines(lines, pattern, to_format)
    vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, new_lines)
    return new_lines
end

function M.convert_function()
    local buf = 0
    local start_line = vim.fn.getpos(".")[2] - 1
    local end_line = vim.fn.getpos(".")[2]
    local line = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)[1]
    if string.match(line, "^function M%.") then
        M.function_from_local_to_public(buf, start_line, end_line)
    elseif string.match(line, "^M%.") then
        M.function_from_public_to_local(buf, start_line, end_line)
    end
end


return M
