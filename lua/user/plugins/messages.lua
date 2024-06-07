require("messages").setup({
    command_name = "Messages",
    -- should prepare a new buffer and return the winid
    -- by default opens a floating window
    -- provide a different callback to change this behaviour
    -- @param opts: the return value from float_opts
    buffer_name = "messages",
    prepare_buffer = function(opts)
        -- for _, win in ipairs(vim.api.nvim_list_wins()) do
        --     if vim.api.nvim_win_get_buf(win) == vim.fn.bufnr("messages") then
        --         -- vim.api.nvim_win_close(win, true)
        --         -- get lines
        --         local lines = vim.api.nvim_buf_get_lines(
        --             vim.fn.bufnr("messages"),
        --             0,
        --             -1,
        --             false
        --         )
        --     end
        -- end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf })
        return vim.api.nvim_open_win(buf, true, opts)
    end,
    -- should return options passed to prepare_buffer
    -- @param lines: a list of the lines of text
    buffer_opts = function(lines)
        local gheight = vim.api.nvim_list_uis()[1].height
        local gwidth = vim.api.nvim_list_uis()[1].width
        return {
            relative = "win",
            width = gwidth - 2,
            height = gheight,
            anchor = "SW",
            row = gheight - 1,
            col = 0,
            style = "minimal",
            border = "rounded",
            zindex = 1,
        }
    end,
    -- what to do after opening the float
    post_open_float = function(winnr)
        -- set background to #000000
        -- vim.api.nvim_win_set_option(
        --     winnr,
        --     "winhighlight",
        --     "NormalFloat:NormalFloat"
        -- )
    end,
})
