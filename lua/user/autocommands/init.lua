-- Autocommands
------------------------------------------------------------------------------
local api = vim.api

--- Create an autocommand group for setting filetypes
local set_filetype_augroup = api.nvim_create_augroup(
  "setFiletype",
  { clear = true }
)

------------------------------------------------------------------------------
--- Set filetype to 'bash' for specific file patterns
api.nvim_create_autocmd(
  "BufReadPost",
  {
    pattern = "*.zshrc," ..
      "*.env," ..
      "*.aliases," ..
      "*.exports," ..
      "*.functions," ..
      "*.zsh-theme," ..
      "*.secrets",
    group = set_filetype_augroup,
    command = "set filetype=bash"
  }
)

--- Set filetype to 'applescript' for specific file patterns and configure
--- indentation settings
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  {
    pattern =
      "*.applescript," ..
      "*.scpt," ..
      "*.scptd,",
    group = set_filetype_augroup,
    -- set tab size to 4 spaces
    command = "set filetype=applescript | set tabstop=4 | set shiftwidth=4 | set expandtab"
  }
)

--- Disable autoformatting of comments in all filetypes
api.nvim_create_autocmd(
  "BufEnter",
  {
    pattern = "*",
    command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
  }
)

api.nvim_create_autocmd(
{ "BufRead", "BufNewFile" },
    {
        pattern = "*.psjs",
        command = "set filetype=javascript",
    }
)
    
    
