vim.g.timeout = true
vim.o.timeoutlen = 50
vim.o.ttimeoutlen = 50
require("which-key").setup {
    plugins = {
        marks = true,         -- shows a list of your marks on ' and `
        registers = true,     -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true,      -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true,      -- default bindings on <c-w>
            nav = true,          -- misc bindings to work with windows
            z = true,            -- bindings for folds, spelling and others prefixed with z
            g = true,            -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
        ['a'] = 'A',
        ['b'] = 'B',
        ['c'] = 'C',
        ['d'] = 'D',
        ['e'] = 'E',
        ['f'] = 'F',
        ['g'] = 'G',
        ['h'] = 'H',
        ['i'] = 'I',
        ['j'] = 'J',
        ['k'] = 'K',
        ['l'] = 'L',
        ['m'] = 'M',
        ['n'] = 'N',
        ['o'] = 'O',
        ['p'] = 'P',
        ['q'] = 'Q',
        ['r'] = 'R',
        ['s'] = 'S',
        ['t'] = 'T',
        ['u'] = 'U',
        ['v'] = 'V',
        ['w'] = 'W',
        ['x'] = 'X',
        ['y'] = 'Y',
        ['z'] = 'Z',
        ['A'] = 'Shift + A',
        ['B'] = 'Shift + B',
        ['C'] = 'Shift + C',
        ['D'] = 'Shift + D',
        ['E'] = 'Shift + E',
        ['F'] = 'Shift + F',
        ['G'] = 'Shift + G',
        ['H'] = 'Shift + H',
        ['I'] = 'Shift + I',
        ['J'] = 'Shift + J',
        ['K'] = 'Shift + K',
        ['L'] = 'Shift + L',
        ['M'] = 'Shift + M',
        ['N'] = 'Shift + N',
        ['O'] = 'Shift + O',
        ['P'] = 'Shift + P',
        ['Q'] = 'Shift + Q',
        ['R'] = 'Shift + R',
        ['S'] = 'Shift + S',
        ['T'] = 'Shift + T',
        ['U'] = 'Shift + U',
        ['V'] = 'Shift + V',
        ['W'] = 'Shift + W',
        ['X'] = 'Shift + X',
        ['Y'] = 'Shift + Y',
        ['Z'] = 'Shift + Z',
        ['1'] = '1',
        ['2'] = '2',
        ['3'] = '3',
        ['4'] = '4',
        ['5'] = '5',
        ['6'] = '6',
        ['7'] = '7',
        ['8'] = '8',
        ['9'] = '9',
        ['0'] = '0',
        ['!'] = 'Shift + 1',
        ['@'] = 'Shift + 2',
        ['#'] = 'Shift + 3',
        ['$'] = 'Shift + 4',
        ['%'] = 'Shift + 5',
        ['^'] = 'Shift + 6',
        ['&'] = 'Shift + 7',
        ['*'] = 'Shift + 8',
        ['('] = 'Shift + 9',
        [')'] = 'Shift + 0',
        ['<'] = 'Shift + ,',
        ['>'] = 'Shift + .',
        ['?'] = 'Shift + /',
        ['"'] = 'Shift + \'',
        [':'] = 'Shift + ;',
        ['+'] = 'Shift + =',
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "･", -- symbol used between a key and it's label
        group = " - ", -- symbol prepended to ajd
    },
    popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>',   -- binding to scroll up inside the popup
    },
    window = {
        border = "none",          -- none, single, double, shadow
        position = "top",      -- bottom, top
        margin = { 25, 100, 0, 0 },  -- extra window margin [top, right, bottom, left]
        padding = { 2, 0, 2, 0 }, -- extra window padding [top, right, bottom, left]
        winblend = 0
    },
    layout = {
        height = { min = 4, max = 25 },                                           -- min and max height of the columns
        width = { min = 20, max = 50 },                                           -- min and max width of the columns
        spacing = 3,                                                              -- spacing between columns
        align = "right",                                                           -- align columns left, center or right
    },
    ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
    -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true,                                                             -- show help message on the command line when the popup is visible
    show_keys = true,                                                             -- show the currently pressed key and its label as a message in the command line
    triggers = "auto",                                                            -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by deafult for Telescope
    disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
    },
}
-- Add a bit of style to the which-key popup

