-- Hammerspoon commands
-- If HammerSpoon is installed, this file will be loaded automatically

local installed = vim.fn.executable('hs') == 1
if not installed then
    vim.notify('Hammerspoon or hs.ipc.cli not installed', vim.log.levels.ERROR)
    return
end

local hs_command = "hs -c "

-- "ConfigHS" to open Hammerspoon config
vim.api.nvim_create_user_command("ConfigHS", function()
    local hs_configdir = vim.fn.system("hs -c 'hs.configdir'")
    local cmd = "edit " .. hs_configdir
    vim.notify(cmd)
    vim.cmd(cmd)
end, {})

-- "RunHS" to run current file in Hammerspoon
vim.api.nvim_create_user_command("RunHS", function()
    local filetype = vim.bo.filetype
    if (filetype == "lua") then
        vim.cmd("VimShellSendString " .. hs_command .. "'dofile(\"%\")'")
    end
end, {})

-- "HS" to run hammerspoon command to cli
vim.api.nvim_create_user_command(
    "HS",
    function(args)
        local query = args.args
        local cmd = hs_command .. "'hs.inspect.inspect(" .. query .. ")'"
        vim.cmd("VimShellSendString " .. cmd)
    end,
    {
        nargs = "*",
        -- complete = function(_, _, _, args)
        --   local hs_cmd = ""
        --   if args.args then
        --     -- replcae " " with "." to match nested keys
        --     hs_cmd = args.args:gsub(" ", ".")
        --     vim.notify(hs_cmd)
        --   end
        --   local cmd = "hs -c 'hs.inspect.inspect(hs." .. hs_cmd .. ", { depth = 1})'"
        --   local output = vim.fn.system(cmd)
        --   -- set regex to match only first nested key definition
        --   local regex = "([%w_]+) ="
        --   local keys = {}
        --   for key in string.gmatch(output, regex) do
        --     table.insert(keys, key)
        --   end
        --   return keys
        -- end
    }
)

-- "HSInspect" to run hammerspoon command to cli and inspect result
vim.api.nvim_create_user_command("HSInspect", function(args)
        -- Show output of hs.inspect in notification
        -- vim command to inspect result
        local output = vim.fn.system("hs -c 'hs.inspect.inspect(" .. args.args .. ")'")
        -- expand shell output to show newlines and tabs
        -- if output is less then 1000 chars
        require("notify")(
            output
            , "info", {
                title = "Hammerspoon",
                on_open = function(win)
                    local buf = vim.api.nvim_win_get_buf(win)
                    vim.api.nvim_buf_set_option(buf, "filetype", "lua")
                end,
            })
    end,
    { nargs = 1, })

-- "HSReload" to reload Hammerspoon config
vim.api.nvim_create_user_command("HSReload", "!hs -c 'hs.reload()'", {})

-- "HSConsole" to open Hammerspoon console
vim.api.nvim_create_user_command("HSConsole", "!hs -c 'hs.openConsole()'", {})

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

vim.keymap.set("n", "<leader>hs", function()
    local cmd = "hs -c 'hs.inspect.inspect(" .. "apps.alacritty" .. ", {depth = 1, newline = \"\"})'"
    local output = vim.fn.system(cmd)
    -- set regex to match only first nested key definition
    local regex = "([%w_]+) ="
    local keys = {}
    for key in string.gmatch(output, regex) do
        table.insert(keys, key)
    end
    keys = vim.inspect(keys)
end, { noremap = true, silent = true })
