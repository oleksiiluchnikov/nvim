vim.g.mapleader = " "

local description = "Test"
vim.keymap.set("n", "<C-M-S-D-o>", ":lua vim.notify('hello')<CR>", { desc = description })
description = "Toggle Terminal"
vim.keymap.set("n", "<C-t>", function()
    require("user.functions").toggle_terminal()
end, { desc = description })
description = "run code"
vim.keymap.set("n", "<D-x>", "<cmd>Run<CR>", { desc = description })
vim.keymap.set("n", "<M-x>", function() end, { desc = "toggle checkbox" })
-- vim.keymap.set("n", "<leader>eC", ":Config nvim<CR>", { desc = "edit nvim config", noremap = true })
vim.keymap.set("n", "<leader>i", function()
    vim.cmd([[!hs -c 'print(apps.photoshop.alias)']])
end, { noremap = false })
vim.keymap.set({ "n", "v" }, "<up>", function()
    require("user.utils").jump_to_next_line_with_same_indent(false, { "end", "-" })
end, { desc = "move to previous line with same indentation" })
vim.keymap.set({ "n", "v" }, "<down>", function()
    require("user.utils").jump_to_next_line_with_same_indent(true, { "end", "-" })
end, { desc = "move to next line with same indentation" })
vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<right>", "<C-w>l")
vim.keymap.set(
    "t",
    "<C-t>",
    "<C-\\><C-n>:lua require('user.functions').toggle_terminal()<CR>",
    { desc = "toggle terminal" }
)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line up" })
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "move line down" })
vim.keymap.set("v", "p", "\"_dP", { desc = "paste from clipboard" })

vim.keymap.set("v", "<leader>mp", function() end, { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<leader>x", "<Plug>SnipRun", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>x", "<Plug>SnipRunOperator", { silent = true })

-- swap ":Ex" with ":Oil" command
vim.api.nvim_create_user_command("Ex", ":Oil", {})
