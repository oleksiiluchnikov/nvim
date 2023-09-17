-- 🔭 Extensions --
local telescope = require('telescope')
-- https://github.com/nvim-telescope/telescope-file-browser.nvim
telescope.load_extension('file_browser')
-- https://github.com/nvim-telescope/telescope-ui-select.nvim
telescope.load_extension('ui-select')
-- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-fzf-nativenvim
telescope.load_extension('fzf')
-- https://github.com/LinArcX/telescope-command-palette.nvim
telescope.load_extension('command_palette')
-- https://github.com/dhruvmanila/telescope-bookmarks.nvim
telescope.load_extension('bookmarks')
-- https://github.com/jvgrootveld/telescope-zoxide
-- <leader>z
telescope.load_extension('zoxide')
-- https://github.com/cljoly/telescope-repo.nvim
-- <leader>rl
telescope.load_extension('repo')

-- https://github.com/AckslD/nvim-neoclip.lua
-- <C-n>
telescope.load_extension('neoclip')

-- GitHub CLI → local version
telescope.load_extension('gh')

-- Text case
telescope.load_extension('textcase')

telescope.load_extension('notify')
telescope.load_extension('media_files')
