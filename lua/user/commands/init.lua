require("user.commands.configs")
require("user.commands.markdown")

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

vim.api.nvim_create_user_command("Chat", function()
    require("user.plugins.shellbot").chatgpt()
end, {})

--- Executes Lua code passed as an argument and prints the result.
---@param lua_code string Lua code to execute
---@return nil
vim.api.nvim_create_user_command("P", function(args)
    -- :execute 'lua require("lazy.core.loader").reload("vault.nvim")' | echo "ok"
    require("lazy.core.loader").reload("vault.nvim")

    ---@type string
    local lua_code = args.fargs[1]

    -- vim.api.nvim_command("lua print(vim.inspect(" .. lua_code .. "))")
    lua_code = string.format("lua print(vim.inspect(%s))", lua_code)

    ---@type string
    vim.cmd(lua_code)

    ---@type number
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_option_value("syntax", "lua", {
        -- win = vim.api.nvim_get_current_win(),
        buf = bufnr,
    })

    vim.api.nvim_set_option_value("relativenumber", true, {
        win = vim.api.nvim_get_current_win(),
        -- buf = bufnr,
    })
end, {
    nargs = "?",
    -- complete = "customlist,v:lua.lazy.plugins.vault.nvim.list",
    -- complete = function(arg_lead, cmd_line, cursor_pos)
    --   -- We need to find same completions like
    --   -- we get when use `complete=command` but
    --   -- if it passed `lua` as first argument.
    -- end,
    complete = "lua",
})

vim.api.nvim_create_user_command("YabaiCenter", function()
    -- do it silently without any notification
    -- vim.cmd("!yabai -m window --grid 3:4:1:1:2:2")
    vim.fn.system("yabai -m window --grid 3:4:1:1:2:2")
end, {})

