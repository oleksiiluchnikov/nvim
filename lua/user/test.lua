-- I need to figure out how to my cursor to the center of the screen when my current line changes
-- If current line is < 20, then I create buffer with 20 lines above the current line,
-- but staying on the same buffer that I am currently on
-- If current line is > 20, then I should buffer delete the buffer that I created

-- FIXME: Issue with LSP attaching to margin buffer: not synax highlighting
-- FIXME: Visual selection disappears when buffer is created, or updated

local M = {}

local margin_buf_name = 'lua'
local cached_lsp_clients = {}

function M.is_margin_buffer()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_get_option(buf, 'filetype') == margin_buf_name then
      return true
    end
  end
  return false
end

function M.center_cursor()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  if current_line == 1 then
    return
  end
  print(current_line)
  -- If cursor is in the top 20 lines, create or update a margin buffer above it.
  if current_line <= 20 then
    vim.cmd('setlocal scrolloff=0')
    if not M.is_margin_buffer() then
      M.create_buffer(20, current_line)
    else
      M.update_buffer(20, current_line)
    end
  elseif current_line > 20 then
    -- If cursor has moved past the 20th line, check for any margin buffers and delete them.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_option(buf, 'filetype') == margin_buf_name then
        M.delete_buffer(buf)
      end
    end
  end
end

function M.create_buffer(buffer_lines, current_line)
  local lsp_client_id = vim.lsp.get_clients()
  if #lsp_client_id > 0 then
    for _, client in ipairs(lsp_client_id) do
      cached_lsp_clients[0] = client.id
      break
    end
  end

  vim.cmd(buffer_lines - 1 .. 'new')
  vim.cmd('setlocal filetype=' .. margin_buf_name)
  vim.cmd('setlocal readonly')
  vim.cmd('setlocal noshowcmd')
  vim.cmd('setlocal winfixheight')
  vim.cmd('setlocal nospell')
  vim.cmd('setlocal nobuflisted')
  vim.cmd('setlocal buftype=nofile')
  vim.cmd('setlocal bufhidden=hide')
  vim.cmd('setlocal noswapfile')
  vim.cmd('set laststatus=3')

  local content = vim.api.nvim_buf_get_lines(0, 0, current_line, false)
  local empty_lines = buffer_lines - #content
  for i = 1, empty_lines do
    table.insert(content, 1, '')
  end
  vim.api.nvim_buf_set_lines(0, 0, buffer_lines, false, content)

  -- Attach LSP to margin buffer
  if cached_lsp_clients[0] then
    vim.lsp.buf_attach_client(0, cached_lsp_clients[0])
  end

  vim.cmd('wincmd p')
  vim.cmd('setlocal scrolloff=0')
  vim.cmd('normal! zt') -- Center cursor on

  M.update_buffer(buffer_lines, current_line)
end

function M.is_lsp_attached(bufnr)
  local clients = vim.lsp.get_clients(bufnr)
  if #clients > 0 then
    return true
  end
  return false
end

function M.attach_lsp_to_margin_buffer(bufnr)
  if not M.is_lsp_attached(bufnr) then
    return
  end
  local lsp_client_id = cached_lsp_clients[bufnr]
  if not lsp_client_id then
    return
  end

  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_get_option(buf, 'filetype') == margin_buf_name then
      if not M.is_lsp_attached(buf) then
        vim.lsp.buf_attach_client(buf, lsp_client_id)
      end
    end
  end
end

function M.update_buffer(buffer_lines, current_line)
  vim.cmd('normal! zt') -- Center cursor on
  local buffers = vim.api.nvim_list_bufs()

  -- Attach LSP to margin buffer
  if not cached_lsp_clients[0] then
    for buffer, client in pairs(cached_lsp_clients) do
      if not M.is_lsp_attached(buffer) then
        vim.lsp.buf_attach_client(buffer, client)
      end
    end
    vim.lsp.buf_attach_client(0, cached_lsp_clients[0])
  end

  local margin_buf
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_get_option(buf, 'filetype') == margin_buf_name then
      margin_buf = buf
      break
    end
  end
  if not margin_buf then
    return
  end

  local content = vim.api.nvim_buf_get_lines(0, 0, current_line, false)
  local empty_lines = buffer_lines - #content
  for i = 1, empty_lines do
    table.insert(content, 1, '')
  end
  vim.api.nvim_buf_set_lines(margin_buf, 0, buffer_lines, false, content)
end

function M.delete_buffer(bufnr)
  vim.cmd('setlocal scrolloff=20')
  vim.api.nvim_buf_delete(bufnr, { force = true })
  -- vim.cmd("normal! zz")
end

-- Autocmd setup
vim.cmd([[
augroup CenterCursorMover
    autocmd!
    autocmd CursorMoved * lua require('user.test').center_cursor()
augroup END
]])

return M
