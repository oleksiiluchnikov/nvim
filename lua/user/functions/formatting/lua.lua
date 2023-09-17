local M = {}
--- Format lua functions from local to public
--- @description Format lua functions from local to public like
--- @example ) to M.foo = function()
--- @param buf number: buffer number
--- @param start_line number: start line
--- @param end_line number: end line
--- @return table: table with new lines
--- @usage functions.function_from_local_to_public(buf)
function M.function_from_local_to_public(buf, start_line, end_line)
    -- line should be visual selected
    local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
    local new_lines = {}
    for _, line in ipairs(lines) do
        local pattern =
        '^function M%.([a-zA-Z0-9_])'
        if string.match(line, pattern) then
            line = string.gsub(line, 'function M%.', 'M.')
            local func_name = string.match(line, 'M%.([a-zA-Z0-9_]+)')
            local args = string.match(line, '%((.*)%)')
            local new_line = 'M.' .. func_name .. ' = function(' .. args .. ')'
            table.insert(new_lines, new_line)
        else
            table.insert(new_lines, line)
        end
    end
    vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, new_lines)
    return new_lines
end

--- Format lua functions from public to local
--- @description Format lua functions from public to local like
--- @example M.foo = function() to )
--- @param buf number: buffer number
--- @param start_line number: start line
--- @param end_line number: end line
--- @return table: table with new lines
--- @usage functions.function_from_public_to_local(buf)
function M.function_from_public_to_local(buf, start_line, end_line)
    local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
    local new_lines = {}
    for _, line in ipairs(lines) do
        local pattern =
        '^M%.([a-zA-Z0-9_])'
        if string.match(line, pattern) then
            local func_name = string.match(line, 'M%.([a-zA-Z0-9_]+)')
            local args = string.match(line, '%((.*)%)')
            line = string.gsub(line, 'M%.', 'function M.')
            local new_line = 'function M.' .. func_name .. '(' .. args .. ')'
            table.insert(new_lines, new_line)
            else
            table.insert(new_lines, line)
        end
    end
    vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, new_lines)
    return new_lines
end


-- Mapppings
------------------------------------------------------------------------------
-- Toggle between local and public function
vim.keymap.set('n', '<leader>cff', function()
    local buf = 0
    local start_line = vim.fn.getpos('.')[2] - 1
    local end_line = vim.fn.getpos('.')[2]
    local pattern = '^function M%.([a-zA-Z0-9_])'
    local pattern2 = '^M%.([a-zA-Z0-9_])'
    local line = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)[1]
        if string.match(line, pattern) then
            M.function_from_local_to_public(buf, start_line, end_line)
        elseif string.match(line, pattern2) then
            M.function_from_public_to_local(buf, start_line, end_line)
        end
end, {noremap = false, silent = false})

return M
