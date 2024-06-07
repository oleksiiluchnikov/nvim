--- Provides user commands for editing Hammerspoon configuration files
--- ===================================================================
--- The user commands "Config" and "ConfigHs" can be used to open the configuration
--- files for Hammerspoon applications in a new buffer. The paths are fetched from
--- Hammerspoon (apps[appname].paths.defaults.config).
---
local M = {}
local has_telescope, _ = pcall(require, "telescope")

--- Fetch the path to the configuration file for a given Hammerspoon application
local function fetch_config_path(alias, key)
    local hs_cmd = "hs.inspect(apps." .. alias .. ".paths." .. key .. ")"
    local path = vim.fn.system("hs -q -c '" .. hs_cmd .. "'")
    -- Be sure it is a path
    -- trim quotes
    path = string.gsub(path, "\"", "")
    -- Verify string is a path
    if path.match(path, "^/.+") then
        return path
    else
        return nil
    end
end

--- Fetch the aliases of the configured Hammerspoon applications
local function fetch_apps()
    local apps_config = vim.fn.system("hs -c 'for k, v in pairs(apps) do print(k) end'")
    local apps_config_keys = vim.split(apps_config, "\n")
    -- replace \n with empty string in each item of the table apps_config_keys
    local apps = {}
    for _, app in ipairs(apps_config_keys) do
        local alias = vim.fn.system("hs -c 'hs.inspect(apps." .. app .. ".alias)'")
        -- filter out strings that starts with "\"[a-zA-Z]+\""
        alias = string.match(alias, "\"([a-zA-Z]+)\"", 1)
        table.insert(apps, alias)
    end
    return apps
end

--- Fetch completions from Hammerspoon
M.completions = fetch_apps()

--- User commands
--- :Config <alias> - Open the configuration file for the given alias
vim.api.nvim_create_user_command("Config", function(args)
    local alias = args.args
    local config_path = fetch_config_path(alias, "config"):gsub("\n", "")
    local is_folder = vim.fn.isdirectory(config_path)
    if config_path and has_telescope then
        if has_telescope then
            require("telescope.builtin").find_files({
                search_dirs = { config_path },
                ignore_files = { "-lock.json" },
            })
        else
            vim.cmd("edit " .. config_path)
        end
    else
        vim.notify("No config path found for " .. alias)
    end
end, {
    nargs = 1, -- means that the command takes one argument (the alias)
    -- add completions from configs module .completions
    complete = function(_, _, _, _, _, _)
        return require("user.commands.configs").completions
    end,
})

--- :ConfigHs <alias> - Open the Hammerspoon configuration file for the given alias
vim.api.nvim_create_user_command("ConfigHs", function(args)
    local alias = args.args
    local config_path = require("user.commands.configs").fetch_config_path(alias, "config_hs")
    if config_path then
        vim.cmd("edit " .. config_path)
    else
        vim.notify("No config path found for " .. alias)
    end
end, {
    nargs = 1,
    -- add completions from configs module .completions
    complete = function(_, _, _, _, _, _)
        return require("user.commands.configs").completions
    end,
})

return M
