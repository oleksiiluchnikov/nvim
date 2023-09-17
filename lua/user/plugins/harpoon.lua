local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { silent = true, desc = "add file to harpoon" })
vim.keymap.set("n", "<leader>j", ui.toggle_quick_menu, { silent = true, desc = "toggle harpoon quick menu" }) -- C is

vim.keymap.set("n", "<C-e>", function() ui.nav_file(1) end, { silent = true, desc = "navigate to harpoon file 1" })
vim.keymap.set("n", "<C-a>", function() ui.nav_file(2) end, { silent = true, desc = "navigate to harpoon file 2" })
vim.keymap.set("n", "<C-h>", function() ui.nav_file(3) end, { silent = true, desc = "navigate to harpoon file 3" })
vim.keymap.set("n", "<C-i>", function() ui.nav_file(4) end, { silent = true, desc = "navigate to harpoon file 4" })
