local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
-- https://github.com/nvim-telescope/telescope.nvim/issues/1048
local telescope_custom_actions = {}

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("cfdo " .. open_cmd)
end

function telescope_custom_actions.multi_selection_open(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

-- @TODOUA: create a git history keyword search picker
-- @TODOUA: add action to commits pickers to yank commit hash

require("telescope").setup {
  extensions = {
    media_files = {
      filetypes = { "png", "webp", "jpg", "jpeg" },
      find_cmd = "fd",
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case", -- this is default
    },
    file_browser = {
      hidden = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_cursor(),
    },
    bookmarks = {
      selected_browser = "google-chrome",
      url_open_command = "open",
    },
    command_palette = {
      {
        "File",
        { "Yank Current File Name", ":lua require('joel.funcs').yank_current_file_name()" },
        { "Write Current Buffer", ":w" },
        { "Write All Buffers", ":wa" },
        { "Quit", ":qa" },
        { "File Browser", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
        { "Search for Word", ":lua require('telescope.builtin').live_grep()", 1 },
        { "Project Files", ":lua require'joel.telescope'.project_files()", 1 },
      },
      {
        "Git(Hub)",
        { " Issues", "lua require'joel.telescope'.gh_issues()", 1 },
        { " Pulls", "lua require'joel.telescope'.gh_prs()", 1 },
        { " Status", "lua require'telescope.builtin'.git_status()", 1 },
        { " Diff Split Vertical", ":Gvdiffsplit!", 1 },
        { " Log", "lua require'telescope.builtin'.git_commits()", 1 },
        {
          " File History",
          ":lua require'telescope.builtin'.git_bcommits({prompt_title = '  ', results_title='Git File Commits'})",
          1,
        },
      },
      {
        "Terminal",
        { "Vertical Right", ":vsp | terminal", 1 },
      },
      {
        "Notes",
        { "Browse Notes", "lua require'joel.telescope'.browse_notes()", 1 },
        { "Find Notes", "lua require'joel.telescope'.find_notes()", 1 },
        { "Search/Grep Notes", "lua require'joel.telescope'.grep_notes()", 1 },
      },
      {
        "Toggle",
        { "cursor line", ":set cursorline!" },
        { "cursor column", ":set cursorcolumn!" },
        { "spell checker", ":set spell!" },
        { "relative number", ":set relativenumber!" },
        { "search highlighting", ":set hlsearch!" },
        { "Colorizer", ":ColorToggle" },
        { "Fold Column", ":lua require'joel.settings'.toggle_fold_col()" },
      },
      {
        "Neovim",
        { "checkhealth", ":checkhealth" },
        { "commands", ":lua require('telescope.builtin').commands()" },
        { "command history", ":lua require('telescope.builtin').command_history()" },
        { "registers", ":lua require('telescope.builtin').registers()" },
        { "options", ":lua require('telescope.builtin').vim_options()" },
        { "keymaps", ":lua require('telescope.builtin').keymaps()" },
        { "buffers", ":Telescope buffers" },
        { "search history", ":lua require('telescope.builtin').search_history()" },
        { "Search TODOS", ":lua require'joel.telescope'.search_todos()" },
      },
    },
  },
  defaults = {
    preview = {
      timeout = 500,
      msg_bg_fillchar = "",
    },
    cwd = '~/.config/nvim',
    multi_icon = " ",
    -- vimgrep_arguments = {
    --   "rg",
    --   "--color=never",
    --   "--no-heading",
    --   "--with-filename",
    --   "--line-number",
    --   "--column",
    --   "--smart-case",
    --   "--hidden",
    -- },
    find_command = {
      "fd",
        "--type",
        "f",
        "--hidden",
        "--follow",
        "--exclude",
        ".git",
    },

    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    sorting_strategy = "ascending",
    color_devicons = true,
    layout_config = {
      prompt_position = "bottom",
      horizontal = {
        width_padding = 0.04,
        height_padding = 0.1,
        preview_width = 0.6,
      },
      vertical = {
        width_padding = 0.05,
        height_padding = 1,
        preview_height = 0.5,
      },
    },

    -- using custom temp multi-select maps
    -- https://github.com/nvim-telescope/telescope.nvim/issues/1048
    mappings = {
      n = {
        ["<Del>"] = actions.close,
        ["<C-A>"] = telescope_custom_actions.multi_selection_open,
      },
      i = {
        ["<esc>"] = actions.close,
        ["<C-A>"] = telescope_custom_actions.multi_selection_open,
      },
    },
    dynamic_preview_title = true,
    winblend = 4,
  },
}

-- Extensions
------------------------------------------------------------------------------
require('user.plugins.telescope.extensions')
require('user.plugins.telescope.mappings')
