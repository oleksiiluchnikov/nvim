local M = {}

---Reorders lines in a buffer to move dataview query lines after frontmatter.
---@param bufnr number Buffer handle
---@return nil
local function replace_dataview_query(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local matched_lines = {} ---@type string[]
    local non_matched_lines = {} ---@type string[]
    local has_frontmatter = lines[1] == "---"
    local start_line = has_frontmatter and 1 or 0

    for _, line in ipairs(lines) do
        if line:match("^[a-z_-]+::.*$") then
            table.insert(matched_lines, line)
        else
            table.insert(non_matched_lines, line)
        end
    end

    if has_frontmatter then
        table.remove(matched_lines, 1)
        for i, line in ipairs(matched_lines) do
            table.insert(non_matched_lines, start_line + i, line)
        end
        matched_lines = non_matched_lines
    else
        for _, line in ipairs(non_matched_lines) do
            table.insert(matched_lines, line)
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, matched_lines)

    return nil
end

vim.api.nvim_create_user_command("RDvQuery", replace_dataview_query, {})

return M
