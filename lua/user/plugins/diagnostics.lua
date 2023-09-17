-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = '',
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = true, -- show virtual text when available
    signs = true,
    update_in_insert = true,
    underline = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = vim.bo.filetype,
        prefix = '     ',
    },
    severity_sort = true,
})


