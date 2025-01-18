return {

    {
        -- [lsp-inlayhints](https://github.com/RishabhRD/lsp-inlayhints.nvim)
        -- Provides inlay hints for LSP
        -----------------------------------------------------------------------
        'lvimuser/lsp-inlayhints.nvim',
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('LspAttach_inlayhints', {}),
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then
                        return
                    end
                    require('lsp-inlayhints').on_attach(client, args.buf)
                end,
            })
        end,
    },
}
