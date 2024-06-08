require("user.commands.configs")
require("user.commands.markdown")

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
    vim.fn.system("yabai -m window --grid 3:4:1:1:2:2")
end, {})
