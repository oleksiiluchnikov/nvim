-- Hammerspoon commands
-- If HammerSpoon is installed, this file will be loaded automatically

local installed = vim.fn.executable('hs') == 1
if not installed then
    vim.notify('Hammerspoon or hs.ipc.cli not installed', vim.log.levels.ERROR)
    return
end

local hs_command = "hs -c "

-- "ConfigHS" to open Hammerspoon config
vim.api.nvim_create_user_command("HSConfig", "lua require('hs').configdir()", {})

-- "RunHS" to run current file in Hammerspoon
vim.api.nvim_create_user_command("RunHS", function()
    local filetype = vim.bo.filetype
    if (filetype == "lua") then
        vim.cmd("VimShellSendString " .. hs_command .. "'dofile(\"%\")'")
    end
end, {})

-- "HS" to run hammerspoon command to cli
-- Run Hammerspoon command via Neovim's command mode
vim.api.nvim_create_user_command(
    "HS",
    function(args)
        local query = args.args
        local cmd = "!" .. "hs.inspect.inspect(" .. query .. ")"
        vim.cmd("VimShellSendString " .. cmd)
    end,
    {
        nargs = "*",
        complete = function(_, _, _, args)
            local hs_cmd = ""
            if args.args then
                -- Replace " " with "." to match nested keys
                hs_cmd = args.args:gsub(" ", ".")
                vim.notify(hs_cmd)
            end
            local inspect_cmd = "hs -c 'hs.inspect.inspect(hs." .. hs_cmd .. ", { depth = 1})'"
            local output = vim.fn.system(inspect_cmd)

            -- Set regex to match only first nested key definition
            local regex = "([%w_]+) ="
            local keys = {}
            for key in string.gmatch(output, regex) do
                table.insert(keys, key)
            end
            return keys
        end
    }
)
-- "HSInspect" to run hammerspoon command to cli and inspect result
vim.api.nvim_create_user_command("HSInspect", function(args)
    require("hs").inspect(args.args)
end, {
    nargs = 1,
})

-- "HSReload" to reload Hammerspoon config
vim.api.nvim_create_user_command("HSReload", function()
    require("hs").reload()
end, {})

-- "HSConsole" to open Hammerspoon console
vim.api.nvim_create_user_command("HSConsole", function()
    require("hs").console()
end, {})

-- "HSSource" to source current file for Hammerspoon
vim.api.nvim_create_user_command("HSSource", function()
    local filetype = vim.bo.filetype
    if (filetype == "lua") then
        -- delete Users/username/.config/hammerspoon/ from path, and trim extension
        local related_path = vim.fn.expand("%:p"):gsub(vim.fn.expand("$HOME") .. "/.config/hammerspoon/", "")
        local path = related_path:gsub(".lua", ""):gsub("/", ".")
        local cmd = "!hs -c 'require(\"" .. path .. "\")'"
        -- vim.notify(cmd)
        vim.cmd(cmd)
    end
end, {})
