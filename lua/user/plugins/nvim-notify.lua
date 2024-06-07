local notify = require('notify')

local default_opts = {
    background_colour = 'NotifyBackground',
    fps = 30,
    icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
    },
    level = 2,
    minimum_width = 50,
    timeout = 400,
    top_down = true,
}

notify.setup(default_opts)

vim.notify = require('notify') -- fancy notifications
