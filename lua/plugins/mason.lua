return {
    {
        -- [mason](https://github.com/williamboman/mason.nvim)
        -- Manages projects and sessions
        -----------------------------------------------------------------------
        'williamboman/mason.nvim',
        opts = {
            ui = {
                icons = {
                    package_installed = '',
                    package_pending = '',
                    package_uninstalled = '',
                },
            },
        },
    },
}
