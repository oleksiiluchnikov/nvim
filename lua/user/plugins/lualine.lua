local status_ok = pcall(require, "lualine")
if not status_ok then
    return
end

local wtf = require('wtf')

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'catppuccin',
        component_separators = { left = '', right = '' },
        -- I want diagonal separators like: "" and "" or "" and "" or "" and "" or "" and ""
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
      -- add cwd to lualine
        lualine_a = { 'mode'},
        -- lualine_b = { function() return vim.fn.getcwd() end, 'branch', 'diff', 'diagnostics' },
        -- lualine_b = { function() return vim.fn.getcwd():gsub(os.getenv('HOME'), '~') end, 'branch', 'diff', 'diagnostics' },
        lualine_c = {{ 'filename', path = 4 }},
        lualine_x = { 'filetype' },
        lualine_y = { },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{ 'filename', path = 1 }},
        lualine_x = {wtf.get_status() },
        lualine_y = {"location"},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
