local M = {}

-- Store the original content of the buffer
local original_content = {}

function M.center_cursor()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]

  local function is_content(line)
    local line_content = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
    return line_content and line_content ~= ''
  end

  local margin_lines = 20

  -- if the first content line alreatdy has 19 empty lines above it, then
  -- we don't need to do anything
  if current_line <= margin_lines and is_content(current_line - 1) then
    if not original_content[1] then
      original_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end
    return
  end

  if current_line <= margin_lines and not is_content(current_line) then
    return
  elseif current_line <= margin_lines and is_content(current_line - 1) then
    if not original_content[1] then
      original_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end
    local empty_lines = {}
    for i = 1, margin_lines - current_line + 1 do
      table.insert(empty_lines, '')
    end
    vim.api.nvim_buf_set_lines(0, 0, 0, false, empty_lines)
  elseif current_line > margin_lines and original_content[1] then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, original_content)
    original_content = {}
  end
end

-- Autocmd setup
vim.cmd([[
augroup CenterCursorMover
    autocmd!
    autocmd CursorMoved * lua require('user.test_2').center_cursor()
augroup END
]])

return M
