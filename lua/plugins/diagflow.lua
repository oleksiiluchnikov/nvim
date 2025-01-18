return {
    {
        -- [diagflow.nvim](https://github.com/dgagn/diagflow.nvim)
        -- Diagnostic information viewer
        -----------------------------------------------------------------------
        'dgagn/diagflow.nvim',
        opts = {
            enable = true,
            max_width = 60, -- The maximum width of the diagnostic messages
            max_height = 10, -- the maximum height per diagnostics
            severity_colors = { -- The highlight groups to use for each diagnostic severity level
                error = 'DiagnosticFloatingError',
                warning = 'DiagnosticFloatingWarn',
                info = 'DiagnosticFloatingInfo',
                hint = 'DiagnosticFloatingHint',
            },
            format = function(diagnostic)
                return diagnostic.message
            end,
            gap_size = 1,
            scope = 'cursor', -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
            padding_top = 0,
            padding_right = 0,
            text_align = 'right', -- 'left', 'right'
            placement = 'inline', -- 'inline', 'floating'
            inline_padding_left = 0, -- the padding left when the placement is inline
            update_event = { 'DiagnosticChanged', 'BufReadPost', 'TextChanged' }, -- the event that updates the diagnostics cache
            toggle_event = { 'InsertEnter' }, -- if InsertEnter, can toggle the diagnostics on inserts
            show_sign = true, -- set to true if you want to render the diagnostic sign before the diagnostic message
            render_event = { 'DiagnosticChanged', 'CursorMoved' },
        },
        event = 'LspAttach',
    },
}
