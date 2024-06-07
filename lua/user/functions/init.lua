vim.user.fn = {}
---fn.format = require('user.functions.format')
local M = {}

--- Generate a new UUID.
---
---@return string uuid: The generated UUID
local function generate_uuid()
    local random = math.random
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local uuid = string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
        return string.format("%x", v)
    end)
  return uuid
end


--- Format a UUID by lowercasing and removing invalid characters.
---
---@param uuid string: The UUID to format
---@return string formatted: The formatted UUID  
local function format_uuid(uuid)
  uuid = uuid:gsub('[%w]', string.lower)
  uuid = uuid:gsub('[^%w]', '')
  return uuid
end

--- Generate and format a UUID.
---
---@return string uuid: The formatted UUID
function M.generate_formatted_uuid()
  local uuid = generate_uuid()
  uuid = format_uuid(uuid)

  return uuid
end

---Put UUID in register
---@description Generate UUID and put it in register
---@usage functions.put_uuid()
---@return nil:
function M.put_uuid()
    local uuid = M.generate_formatted_uuid()
    vim.api.nvim_put({ uuid }, "c", true, true)
end

---Toggle VimShell terminal window (:VimShell)
---@description If terminal in any split is open, close it. If terminal is closed, open it in current split with (:vsplit | VimShell)
---@usage functions.toggle_terminal()
---@return nil
function M.toggle_terminal()
    local terminal = "vimshell"
    local is_buf_exist = function()
        local buf_exist = false
        local shell_buf = vim.fn.bufnr(terminal) -- get vimshell buffer number
        if shell_buf ~= -1 then
            buf_exist = true
            return buf_exist
        end
        return buf_exist
    end
    local is_focused = function()
        local focused = false
        local current_win = vim.fn.win_getid() -- get current window id
        local current_buf = vim.fn.winbufnr(current_win) -- get current buffer number
        local shell_buf = vim.fn.bufnr(terminal) -- get vimshell buffer number
        if current_buf == shell_buf then
            focused = true
            return focused
        end
        return focused
    end

    local is_split_exist = function()
        local split_exist = false
        local shell_buf = vim.fn.bufnr(terminal) -- get vimshell buffer number
        local shell_win = vim.fn.bufwinid(shell_buf) -- get vimshell window id
        if shell_win ~= -1 then
            split_exist = true
            return split_exist
        end
        return split_exist
    end

    if is_buf_exist() then
        if is_split_exist() then
            if is_focused() then
                vim.cmd("q")
            else
                vim.cmd("wincmd p")
                vim.cmd("q")
            end
            return
        end
        vim.cmd("vsplit | VimShell")
    else
        vim.cmd("vsplit | VimShell")
    end
end

---Exit VimShell terminal window (:VimShellPop)
---@description Exit VimShell terminal window (:VimShellPop)
---@usage functions.close_terminal()
function M.close_terminal()
    -- functions.close_terminal()
    -- Function
    -- Exit VimShell terminal window (:VimShellPop)
    -- Parameters:
    -- * None
    -- Usage:
    -- * <leader>te

    -- find buffer with terminal
    local terminal = "vimshell"
    local buffers = vim.api.nvim_list_bufs()
    local is_exist = function(buf)
        -- Function
        -- Check if buffers vimshell is exists in buffers
        -- Parameters:
        -- * buf: buffer number

        -- Return: boolean
        return vim.fn.bufname(buf) == terminal -- bufname returns buffer name by number (buf)
    end
    local is_focused = function(buf)
        -- Function
        -- Check if buffer vimshell is focused
        -- Parameters:
        -- * buf: buffer number

        -- Return: boolean
        return vim.api.nvim_win_get_buf(0) == buf -- get current buffer number in current window and compare it with buffer number of vimshell buffer
    end
    if is_exist(vim.fn.bufnr(terminal)) then -- if vimshell is exists
        vim.cmd("b " .. terminal) -- focus it
        vim.cmd("q") -- close it
        return
    else
        return
    end
end

---Open VimShell in floating window
---@description Open VimShell in floating window
---@usage functions.open_terminal()
---@return nil
function M.open_terminal()
    -- functions.open_terminal()
    -- Function
    -- Open VimShell in floating window
    -- Parameters:
    -- * None
    -- Usage:
    -- * <leader>to

    local win = vim.fn.win_getid()
    local term = vim.fn.win_gettype(win)
    if term == "terminal" then
        vim.cmd("q")
    else
        vim.cmd("VimShell")
    end
end

---place M to fn
vim.user.fn = M

function M.write_then_source()
    vim.cmd("write")
    local filetype = vim.bo.filetype
    if filetype == "lua" then
        local current_path = vim.fn.expand("%:p")
        if type(current_path) ~= "string" then
            return
        end
        if current_path:find("config/hammerspoon") ~= nil then
            vim.execute("hs -c \"hs.reload()\"")
        else
            vim.cmd("luafile %")
        end
        vim.cmd("source %")
    end
end

vim.keymap.set("n", "<leader>xx", function()
    M.write_then_source()
end, { desc = "write and source current file" })

-- reltimestr({time})                                                *reltimestr()*
-- 		Return a String that represents the time value of {time}.
-- 		This is the number of seconds, a dot and the number of
-- 		microseconds.  Example: >vim
-- 			let start = reltime()
-- 			call MyFunction()
-- 			echo reltimestr(reltime(start))
-- <		Note that overhead for the commands will be added to the time.
-- 		Leading spaces are used to make the string align nicely.  You
-- 		can use split() to remove it. >vim
-- 			echo split(reltimestr(reltime(start)))[0]
-- <		Also see |profiling|.
-- 		If there is an error an empty string is returned
local function measure_time(func)
  local start = vim.fn.reltime()
  func()
  local str = vim.fn.reltimestr(vim.fn.reltime(start))
  return str
end

--- Measure execution time of a function.
---
---@param name string: The name of the function
---@param func function: The function to benchmark
---@return nil
function M.benchmark(name, func)
    local time_str = measure_time(func)
  vim.api.nvim_echo({{time_str .. " " .. name, "String"}}, true, {})
end

B = M.benchmark

vim.user.fn = M

return M
