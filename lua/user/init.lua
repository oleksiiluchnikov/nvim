if vim.user then
    error("vim.user is already defined")
end
-- a table to store user configurations
vim.user = {}
vim.deprecate = function() end

-- vim.opt.runtimepath:append(vim.fn.getcwd() .. "/**")
-- vim.opt.runtimepath:append(
--     vim.fn.getenv("HOME") .. "/.local/share/nvim/lazy/**"
-- )

-- Settings
require("user.utils")
require("user.git")
require("user.plugins")
require("user.options")
require("user.commands")
require("user.autocommands")
require("user.mappings")
require("user.functions")
require("user.plugins.nvim-notify")
