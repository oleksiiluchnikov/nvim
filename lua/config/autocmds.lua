-- Use a more descriptive name for the autocmd group
local autocmd_group =
    vim.api.nvim_create_augroup('MoveToMarkAndCenter', { clear = true })

-- Use the autocmd_group to create the autocmd
vim.api.nvim_create_autocmd('BufReadPost', {
    group = autocmd_group,
    -- callback = require('config.utils').move_to_mark_and_center,
    callback = require('config.utils.buf').move_to_mark_and_center,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
    group = autocmd_group,
    pattern = '*',
    callback = function()
        local save_cursor = vim.fn.getpos('.')
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos('.', save_cursor)
    end,
})

-- Optimize yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = autocmd_group,
    command = 'silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=25})',
})

local osascript_cmd_fmt = 'osascript -e "set the clipboard to %q"'
local osascript_cmd = string.format(osascript_cmd_fmt, '')

vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = autocmd_group,
    callback = function()
        local yanked_text = vim.fn.getreg('"')
        osascript_cmd = string.format(osascript_cmd_fmt, yanked_text)
        vim.cmd('!' .. osascript_cmd)
    end,
})

--- Sets the filetype for various file extensions
local function set_filetypes()
    -- Precompute file patterns for better performance
    local file_patterns = {
        -- Table of file patterns for the 'zsh' filetype
        zsh = {
            '%.zshrc$',
            '%.env$',
            '%.aliases$',
            '%.exports$',
            '%.functions$',
            '%.zsh-theme$',
            '%.secrets$',
            '%rc$',
        },
        -- Table of file patterns for the 'javascript' filetype
        javascript = {
            '%.psjs$',
            '%.js$',
        },
        -- Table of file patterns for the 'applescript' filetype
        applescript = {
            '%.applescript$',
            '%.scpt$',
            '%.scptd$',
        },
    }

    -- Create a single autocmd group for all file patterns
    local augroup_filetype =
        vim.api.nvim_create_augroup('setFiletype', { clear = true })

    --- Sets the filetype for a given set of file patterns
    --- @param filetype string The filetype to set
    --- @param patterns table<number, string> A table of file patterns
    local function set_filetype(filetype, patterns)
        -- Use a single autocmd with a combined pattern for better performance
        vim.api.nvim_create_autocmd('BufReadPost', {
            pattern = table.concat(patterns, '\\|'), -- Use '\\|' to combine patterns
            group = augroup_filetype,
            command = 'set filetype=' .. filetype,
        })
    end

    -- Set filetypes for all file patterns
    for filetype, patterns in pairs(file_patterns) do
        if filetype == 'applescript' then
            -- Special case for applescript filetype
            -- Use a single autocmd with a combined pattern for better performance
            vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
                pattern = table.concat(patterns, '\\|'), -- Use '\\|' to combine patterns
                group = augroup_filetype,
                command = 'set filetype=applescript | set tabstop=4 | set shiftwidth=4 | set expandtab',
            })
        else
            set_filetype(filetype, patterns)
        end
    end
end

-- Call the set_filetypes function
set_filetypes()

-- -- Dim inactive windows
-- vim.cmd('highlight default DimInactiveWindow guifg=#000000')
--
-- -- When leaving a window, set all highlight groups to 'dimmed' hl_group
-- vim.api.nvim_create_autocmd('WinLeave', {
--     group = autocmd_group,
--     callback = function()
--         local highlights = {}
--
--         for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
--             table.insert(highlights, hl .. 'DimInactiveWindow')
--         end
--         vim.wo.winhighlight = table.concat(highlights, ',')
--     end,
-- })
--
-- -- When entering a window, set all highlight groups to 'Normal' hl_group
-- vim.api.nvim_create_autocmd('WinEnter', {
--     group = autocmd_group,
--     callback = function()
--         vim.wo.winhighlight = ''
--     end,
-- })

--- Force AI completions to be triggered in EX mode line in(C-f) they need to have filenname for buffer
-- vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
--     group = require('supermaven-nvim.document_listener').group,
--     callback = function()
--         local config = require('supermaven-nvim.config')
--         local buffer = vim.api.nvim_get_current_buf()
--         local file_name = vim.api.nvim_buf_get_name(buffer)
--         if not file_name or not buffer then
--             vim.notify('No file name or buffer found', vim.log.levels.ERROR)
--             return
--         end
--         if config.condition() then
--             -- binary:on_update(buffer, file_name, 'cmdline_enter')
--             require('supermaven-nvim.binary.binary_handler'):on_update(
--                 buffer,
--                 file_name,
--                 'cmdline_enter'
--             )
--         end
--     end,
-- })
