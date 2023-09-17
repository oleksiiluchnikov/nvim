-----------------------------------
local has_functions, functions = pcall(require, 'user.functions')
if not has_functions then
    vim.notify("user.functions not found")
    return
end

    local get_root_dir = function()
        local dir = vim.fn.expand('%:p:h')
        local git_dir = vim.fn.finddir('.git', dir .. ';')
        return git_dir and git_dir:match("(.*/)") or dir
    end
-- <leader> then [f]
------------------------------------------------------------------------------
vim.g.mapleader = " " -- set leader key to space

------------------------------------------------------------------------------
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line up" })
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "move line down" })

------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "back to netrw" })

------------------------------------------------------------------------------
vim.keymap.set("v", "p", '"_dP', { desc = "paste from clipboard" })
------------------------------------------------------------------------------

------------------------------------------------------------------------------
vim.keymap.set("n", "<C-t>", ":lua require('user.functions').toggle_terminal()<CR>", { desc = "toggle terminal" })
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>:lua require('user.functions').toggle_terminal()<CR>",
    { desc = "toggle terminal" })

------------------------------------------------------------------------------
vim.keymap.set("n", "<M-x>", function() -- toggle checkbox
        -- knowledge.checkboxes.toggle_checkbox()
    end,
    { desc = "toggle checkbox" })

------------------------------------------------------------------------------
vim.keymap.set("n", "<D-x>", "<cmd>Run<CR>", { desc = "run code" })

------------------------------------------------------------------------------
vim.keymap.set("n", "<C-M-S-D-o>", ":lua vim.notify('hello')<CR>", { desc = "notify" })

-- <leader> then [s]
------------------------------------------------------------------------------
-- vim.keymap.set('v', '<leader>gd', 'y<ESC>:Telescope live_grep default_text=<c-r>0<CR>', { noremap = false , silent = true})

vim.keymap.set("n", "<leader>e", ":Config nvim<CR>", { desc = "edit nvim config", noremap = true})

-- <leader> then [r]
------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>x", ":Run<CR>", { desc = "run code" , noremap = true})

vim.keymap.set("n", "<leader>i", function()
    -- run shell command
    vim.cmd [[!hs -c 'print(apps.photoshop.alias)']]
end, { noremap = false })
