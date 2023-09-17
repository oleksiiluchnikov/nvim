require('copilot').setup({
    panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
            jump_prev = "<M-p>",
            jump_next = "<M-n>",
            open = "<M-CR>"
        },
        layout = {
            position = "right", -- | top | left | right
            ratio = 0.4
        },
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 10, 
    },
    -- Allow to be enabled in all filetypes
    filetypes = { ['*'] = true },
    copilot_node_command = 'node', -- Node.js version must be > 16.x
    server_opts_overrides = {},
})

-- recolor the copilot comment highlight group
vim.cmd [[highlight CopilotSuggestion guifg=#408500 gui=italic]]
