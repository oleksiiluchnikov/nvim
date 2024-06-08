--- Create an autocommand group for setting filetypes
local set_filetype_augroup = vim.api.nvim_create_augroup("setFiletype", { clear = true })
if not vim.lsp.handlers["textDocument/formatting"] then
    return
end

--- Set filetype to zsh for common zsh config files on buffer read
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.zshrc,"
        .. "*.env,"
        .. "*.aliases,"
        .. "*.exports,"
        .. "*.functions,"
        .. "*.zsh-theme,"
        .. "*.secrets",
    group = set_filetype_augroup,
    command = "set filetype=zsh",
})

--- Set filetype to 'javascript' for specific file patterns
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.psjs",
    group = set_filetype_augroup,
    command = "set filetype=javascript",
})

--- Set filetype to 'applescript' for specific file patterns and configure
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.applescript," .. "*.scpt," .. "*.scptd,",
    group = set_filetype_augroup,
    -- set tab size to 4 spaces
    command = "set filetype=applescript | set tabstop=4 | set shiftwidth=4 | set expandtab",
})
--
-- --- Disable autoformatting of comments in all filetypes
-- api.nvim_create_autocmd(
--         "BufEnter",
--         {
--                 pattern = "*",
--                 command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
--         }
-- )
--

-- --- Set conditional indentation settings for specific file patterns on save
-- api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*.applescript,' .. '*.scpt,' .. '*.scptd,',
--   command = 'set tabstop=4 | set shiftwidth=4 | set expandtab',
--   group = set_formatter_augroup,
-- })
--
-- api.nvim_create_autocmd({ 'BufReadPost' }, {
--   pattern = '*.rb,' -- Ruby
--     .. '*.yml,' -- YAML
--     .. '*.yaml,' -- YAML
--     .. '*.lua,' -- Lua
--     .. '*.json,' -- JSON
--     .. '*.ts,' -- TypeScript
--     .. '*.tsx,' -- TSX
--     .. '*.scss,' -- SCSS (though this can vary)
--     .. '*.sass,' -- SASS (specifically the indented syntax)
--     .. '*.md,' -- Markdown
--     .. '*.mdx,' -- MDX
--     .. '*.toml,' -- TOML
--     .. '*.html,' -- HTML (though this can vary based on personal/team preference)
--     .. '*.css,' -- CSS (though this can vary)
--     .. '*.vue,' -- Vue.js single file components
--     .. '*.coffee,' -- CoffeeScript
--     .. '*.haml,' -- Haml
--     .. '*.slim,' -- Slim
--     .. '*.jade,' -- Jade/Pug
--     .. '*.pug,' -- Pug
--     .. '*.styl', -- Stylus
--   command = 'set tabstop=2 | set shiftwidth=2 | set expandtab',
--   group = set_formatter_augroup,
-- })
--
-- --- Autoformat on write for any file patterns
-- -- api.nvim_create_autocmd({ 'BufWritePost' }, {
-- --   pattern = '*',
-- --   command = 'FormatWrite',
-- --   group = set_formatter_augroup,
-- -- })
--
-- --- Autoformat on enter lua files
-- api.nvim_create_autocmd({ 'BufReadPost' }, {
--   pattern = '*.lua',
--   command = 'FormatWrite',
--   group = set_formatter_augroup,
-- })

-- au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    command = "silent! lua vim.highlight.on_yank {higroup=\"IncSearch\", timeout=50}",
})
--
-- augroup FormatAutogroup
--   autocmd!
--   autocmd BufWritePost * FormatWrite
-- augroup END
