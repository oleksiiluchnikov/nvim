---@type fun(client: lsp.Client, bufnr: number)
local on_attach = require("user.plugins.lsp.on_attach")
require("sg").setup({
    on_attach = on_attach,
})
-- Init Cody
require("user.plugins.sg.cody")

-- Make autocommand to set win width of floating window
-- as it now not supported by sg.nvim

-- The Idea is to set the width of floating window to 0.8 of the screen
-- after it is created

-- Then we need to create the autogroup
vim.api.nvim_create_augroup("Sourcegraph", {
    clear = true,
})

-- Then we need to create the autocommand
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    callback = function()
        -- First we need to get the width of the screen
        local screen_width = vim.api.nvim_list_uis()[1].width
        local width = math.floor(screen_width * 0.5)

        -- Then we need to calculate the width of the floating window
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        -- if current buffer has "Cody History" in it's name
        local bufname = vim.api.nvim_buf_get_name(buf)
        if not string.find(bufname, "Cody History") then
            return
        end
        vim.api.nvim_win_set_width(0, width)
    end,
})

-- If the current buffer is a floating window
-- then place align in to the bootom of the screen
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    callback = function()
        -- Detect if the current buffer is a floating window
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        -- if current buffer has "Cody History" in it's name
        local bufname = vim.api.nvim_buf_get_name(buf)
        if not string.find(bufname, "Cody History") then
            return
        end

        -- First we need to get the width of the screen
        local screen_width = vim.api.nvim_list_uis()[1].width
        local screen_height = vim.api.nvim_list_uis()[1].height
        local width = math.floor(screen_width * 0.8)
        local height = math.floor(screen_height * 0.3)

        -- Then we need to calculate the width of the floating window
        vim.api.nvim_win_set_width(0, width)
        vim.api.nvim_win_set_height(0, height)
        vim.api.nvim_win_set_config(0, {
            relative = "editor",
            row = 0,
            col = 0,
        })
    end,
})
