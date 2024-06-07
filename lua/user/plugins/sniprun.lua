require('sniprun').setup({
        interpreter_options = { --# interpreter-specific options, see doc / :SnipInfo <name>

                --# use the interpreter name as key
                GFM_original = {
                        use_on_filetypes = { "markdown.pandoc" } --# the 'use_on_filetypes' configuration key is
                        --# available for every interpreter
                },
                Python3_original = {
                        error_truncate = "auto" --# Truncate runtime errors 'long', 'short' or 'auto'
                }
        },

        --# you can combo different display modes as desired and with the 'Ok' or 'Err' suffix
        --# to filter only sucessful runs (or errored-out runs respectively)
        display = {
                "Classic", --# display results in the command-line  area
                "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)

                -- "VirtualText",             --# display results as virtual text
                -- "TempFloatingWindow",      --# display results in a floating window
                -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText[Ok/Err]
                -- "Terminal",                --# display results in a vertical split
                -- "TerminalWithCode",        --# display results and code history in a vertical split
                "NvimNotify", --# display with the nvim-notify plugin
                -- "Api"                      --# return output to a programming interface
        },

        live_display = { "VirtualTextOk" }, --# display mode used in live_mode

        display_options = {
                terminal_scrollback = vim.o.scrollback, --# change terminal display scrollback lines
                terminal_line_number = false, --# whether show line number in terminal window
                terminal_signcolumn = false, --# whether show signcolumn in terminal window
                terminal_persistence = true, --# always keep the terminal open (true) or close it at every occasion (false)
                terminal_width = 45,        --# change the terminal display option width
                notification_timeout = 2    --# timeout for nvim_notify output
        },

        --# You can use the same keys to customize whether a sniprun producing
        --# no output should display nothing or '(no output)'
        show_no_output = {
                "NvimNotify", --# for example, no output in NvimNotify
                "Classic",
                "TempFloatingWindow", --# implies LongTempFloatingWindow, which has no effect on its own
        },


        live_mode_toggle = 'off', --# live mode toggle, see Usage - Running for more info

        --# miscellaneous compatibility/adjustement settings
        inline_messages = false, --# boolean toggle for a one-line way to display messages
        --# to workaround sniprun not being able to display anything

        borders = 'single', --# display borders around floating windows
        --# possible values are 'none', 'single', 'double', or 'shadow'
})
