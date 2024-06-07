local M = {}

local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')
local from_entry = require('telescope.from_entry')
local harpoon_mark = require('harpoon.mark')

function M._multiopen(prompt_bufnr, open_cmd)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd('cfdo ' .. open_cmd)
end

function M.multi_selection_open(prompt_bufnr)
  M._multiopen(prompt_bufnr, 'edit')
end

local function get_selections(prompt_bufnr)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local selections = {}

  if #picker:get_multi_selection() > 0 then
    selections = picker:get_multi_selection()
  else
    table.insert(selections, actions_state.get_selected_entry())
  end

  return selections
end

function M.send_selected_to_harpoon(prompt_bufnr)
  local selections = get_selections(prompt_bufnr)

  for _, entry in ipairs(selections) do
    local filename = from_entry.path(entry, false, false)

    if filename then
      harpoon_mark.add_file(filename)
    end
  end

  actions.close(prompt_bufnr)
end

return M
