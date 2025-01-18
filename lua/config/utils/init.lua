function P(v)
    local Popup = require('nui.popup')
    local text

    if type(v) == 'function' then
        local tbl = require('config.utils').get_function_source(v)

        if not tbl then
            vim.notify('Could not get function source', vim.log.levels.ERROR, {
                title = 'ERROR',
            })
            return nil
        end
        require('telescope.builtin').live_grep({
            default_text = tbl.func_name,
            search_dirs = { tbl.path_to_parent },
        })
        return nil
    end
    text = vim.inspect(v)

    local win_config = {
        enter = true,
        relative = 'editor',
        focusable = true,
        border = {
            style = 'rounded',
        },
        position = '50%',
        size = {
            width = '80%',
            height = '90%',
        },
        buf_options = {
            buftype = '',
        },
        win_options = {
            winhighlight = 'Normal:Normal',
            number = true,
        },
    }

    local popup = Popup(win_config)
    popup:mount()
    if text:len() < 10000 then
        local dummy_filename = 'inspect.lua'
        local filetype = 'lua'
        vim.api.nvim_buf_set_name(popup.bufnr, dummy_filename)
        vim.api.nvim_set_option_value(
            'filetype',
            filetype,
            { buf = popup.bufnr }
        )
        vim.api.nvim_set_option_value('buftype', '', { buf = popup.bufnr })
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, true, vim.split(text, '\n'))

    vim.api.nvim_set_option_value('modifiable', false, { buf = popup.bufnr })
    vim.api.nvim_set_option_value('readonly', true, { buf = popup.bufnr })

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'q', function()
        popup:unmount()
    end, opts)

    popup:on('BufLeave', function()
        popup:unmount()
    end)

    return v
end

function R(_package)
    package.loaded[_package] = nil
    return require(_package)
end

function T()
    print(require('nvim-treesitter.ts_utils').get_node_at_cursor():type())
end

--- Safe require for loading modules, with error handling
---@diagnostic disable: lowercase-global
function require_safe(module_name)
    -- macro around pcall to handle errors and send logs
    -- it uses pcall to require the module and, if it fails, it sends a log
    -- message to the user.
    local status_ok, module = pcall(require, module_name)
    if not status_ok then
        vim.notify(
            'loading ' .. module_name .. ' failed: ' .. module,
            vim.log.levels.WARN
        )
        return
    end
    return require(module_name)
end

--- Measures the execution time of a function and prints it to the Neovim command line.
---
--- This function takes a function as an argument, executes it, and measures the time it takes to complete.
--- The measured time is then printed to the Neovim command line, along with the provided name for the function.
---
--- @param name string -- The name or description of the function being benchmarked.
--- @param func function -- The function to be benchmarked.
---
--- @usage
--- ```lua
--- -- Example usage:
--- local function my_function()
---     -- Some time-consuming operation
---     vim.fn.sleep(1000)
--- end
---
--- require('config.utils').benchmark("My Function", my_function)
--- -- Output: "1.001s My Function"
--- ```
--- @return nil
function B(name, func)
    local start_time = vim.fn.reltime()
    func()
    local elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    vim.api.nvim_echo({ { elapsed_time .. ' ' .. name, 'String' } }, true, {})
end
