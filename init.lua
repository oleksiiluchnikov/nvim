vim.g.mapleader = ' '       -- Set the leader key to Space
vim.g.maplocalleader = ' '  -- Set the local leader key to Space
vim.g.have_nerd_font = true -- Set to true if you have a nerd font

-- Window settings
-------------------------------------------------------------------------------
vim.opt.splitright = true  -- Split windows vertically to the right
vim.opt.wrap = false       -- Disable line wrapping
vim.opt.signcolumn = 'yes' -- Show sign column

-- GUI settings
-------------------------------------------------------------------------------
vim.opt.guicursor = ''       -- Hide the cursor in GUI mode
vim.opt.termguicolors = true -- Use true color in the terminal

-- Line numbering
-------------------------------------------------------------------------------
vim.opt.nu = true             -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

-- Tabs and indentation
-------------------------------------------------------------------------------
vim.opt.formatoptions = 'crqnj' -- Set the format options
vim.opt.tabstop = 4             -- Set the tabstop to 4 spaces
vim.opt.softtabstop = 4         -- Set the soft tabstop to 4 space
vim.opt.shiftwidth = 4          -- Set the shiftwidth to 4 spaces
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.smartindent = true      -- Enable smart indentation

-- File management
-------------------------------------------------------------------------------
vim.opt.swapfile = false                               -- Disable swap file creation
vim.opt.backup = false                                 -- Disable backup file creation
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- Set the undo directory
vim.opt.undofile = true                                -- Enable undo persistence

-- Search settings
-------------------------------------------------------------------------------
vim.opt.hlsearch = true  -- Enable search highlighting
vim.opt.incsearch = true -- Incremental search

-- Miscellaneous settings
-------------------------------------------------------------------------------
vim.opt.isfname:append('@-@')       -- Include '@' in isfname
vim.opt.updatetime = 50             -- Set the update time
vim.opt.colorcolumn = '80'          -- Highlight the 80th column
vim.g.netrw_banner = 0              -- Disable netrw banner
vim.g.italic_comments = false       -- Disable italic comments
vim.g.netrw_list_hide = '.DS_Store' -- Ignore .DS_Store files in netrw
vim.g.netrw_browse_split = 0        -- Open netrw in the current window
-- let $NVIM_LSP_LOG_FILE = '/path/to/your/logfile.log'
-- in lua will be vim.env.NVIM_LSP_LOG_FILE
vim.env.NVIM_LSP_LOG_FILE = '/tmp/nvim.log'

-- Complete settings
-------------------------------------------------------------------------------
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' } -- Set the complete options
vim.opt.shortmess = vim.opt.shortmess + { c = true }        -- Disable completion messages
vim.opt.updatetime = 300                                    -- Set the update time
vim.opt.shada = { '!', '\'1000', '<50', 's10', 'h' }        -- Set the ShaDa options to save the history

--------------------------------------------------------------------------------
if vim.u then
    error('vim.u is already defined')
end

--- Namespace for user-specific functions and variables
vim.u = {}
--------------------------------------------------------------------------------

--- Namespace for usre styles
vim.u.styles = {}

--- Border styles for floating windows
vim.u.styles.borders = {
    single = {
        { '┌', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '┐', 'FloatBorder' },
        { '│', 'FloatBorder' },
        { '┘', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '└', 'FloatBorder' },
        { '│', 'FloatBorder' },
    },
    bold = {
        { '┏', 'FloatBorder' },
        { '━', 'FloatBorder' },
        { '┓', 'FloatBorder' },
        { '┃', 'FloatBorder' },
        { '┛', 'FloatBorder' },
        { '━', 'FloatBorder' },
        { '┗', 'FloatBorder' },
        { '┃', 'FloatBorder' },
    },
    solid = {
        { '▛', 'FloatBorder' },
        { '▀', 'FloatBorder' },
        { '▜', 'FloatBorder' },
        { '▌', 'FloatBorder' },
        { '▙', 'FloatBorder' },
        { '▀', 'FloatBorder' },
        { '▟', 'FloatBorder' },
        { '▌', 'FloatBorder' },
    },
    double = {
        { '╔', 'FloatBorder' },
        { '═', 'FloatBorder' },
        { '╗', 'FloatBorder' },
        { '║', 'FloatBorder' },
        { '╝', 'FloatBorder' },
        { '═', 'FloatBorder' },
        { '╚', 'FloatBorder' },
        { '║', 'FloatBorder' },
    },
    solid_double = {
        { '╭', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '╮', 'FloatBorder' },
        { '│', 'FloatBorder' },
        { '╯', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '╰', 'FloatBorder' },
        { '│', 'FloatBorder' },
    },
}

--------------------------------------------------------------------------------

-- Namespace for uri functions
vim.u.uri = {}

--- Percent encode a string
--- ```lua
--- local encoded = vim.u.uri.encode('https://oleksii-luchnikov.com')
--- assert(encoded == 'https%3A%2F%2Foleksii-luchnikov.com')
--- ```
--- @param str string
function vim.u.uri.encode(str)
    -- return str:gsub('([^%w ])', function(c)
    return string.gsub(str, '([^%w ])', function(c)
        return string.format('%%%02X', string.byte(c))
    end)
end

--- Percent decode a string
--- ```lua
--- local decoded = vim.u.uri.decode('https%3A%2F%2Foleksii-luchnikov.com')
--- assert(decoded == 'https://oleksii-luchnikov.com')
--- ```
--- @param str string
function vim.u.uri.decode(str)
    return string.gsub(str, '%%(%x%x)', function(hex)
        return string.char(tonumber(hex, 16))
    end)
end

--- Validate if a string is a valid uri
--- TODO: Add more advanced validation
--- ```lua
--- local is_valid = vim.u.uri.validate('https://oleksii-luchnikov.com')
--- assert(is_valid)
--- ```
--- @param str string
--- @return boolean
function vim.u.uri.validate(str)
    return str:match('^%w+://')
end

--------------------------------------------------------------------------------

--- Namespace for utils functions
vim.u.utils = {}

---@alias LuaVersion string
---|> 'LuaJIT'
---|> 'Lua 5.1'
---|> 'Lua 5.2'
---|> 'Lua 5.3'
---|> 'Lua 5.4'

---Get the lua version of the current buffer
---
---@return LuaVersion
---```lua
---local lua_version = vim.u.utils.get_lua_version()
---assert(lua_version == 'LuaJIT' or lua_version == 'Lua 5.1')
---```
function vim.u.utils.get_lua_version()
    local buffer_path = tostring(vim.fn.expand('%:p:h'))
    local nvim_path = tostring(vim.fn.stdpath('config'))
    local is_neovim = string.find(buffer_path, nvim_path) and true or false
    local is_hammerspoon = string.find(buffer_path, 'hammerspoon') and true
        or false

    ---@type LuaVersion
    local lua_version

    if is_neovim then
        lua_version = 'LuaJIT'
    elseif is_hammerspoon then
        local lua_version_str =
            vim.fn.system('hs -c _VERSION'):gsub('[\n\r]', '')
        if lua_version_str:match('^error') then
            vim.notify(lua_version_str, vim.log.levels.ERROR, {
                title = 'Neovim',
            })
        end
        ---@diagnostic disable-next-line: cast-local-type
        lua_version = lua_version_str
    else
        lua_version = 'LuaJIT'
    end

    return lua_version
end

---Get start and end lines for code selection
---```lua
---local start_line, end_line = get_selection_lines()
---assert(start_line >= 1)
---if end_line ~= nil then
---    assert(end_line >= start_line)
---end
---```
---@return integer start_line
---@return integer end_line # Can be nil if no selection
function vim.u.utils.get_selection_lines()
    local _, lnum_start, _, _, _ = unpack(vim.fn.getpos('\'<'))
    local _, lnum_end, _, _, _ = unpack(vim.fn.getpos('\'>'))
    return lnum_start, lnum_end
end

---Get the current visual selection formatted for markdown.
---```lua
---local selection_in_fences = get_visual_selection_markdown(
---    'lua',
---    vim.api.nvim_get_current_buf(),
---    start_line,
---    end_line
---)
---
---assert(selection_in_fences:match('^```lua\n'))
---assert(selection_in_fences:match('\n```$'))
---```
---@param filetype string The filetype of the current buffer
---@param bufnr integer The buffer number of the current buffer
---@param start_line integer The starting line number of the selection
---@param end_line integer The ending line number of the selection
---@return string selection in fenced markdown code block.
function vim.u.utils.get_visual_selection_markdown(
    filetype,
    bufnr,
    start_line,
    end_line
)
    ---@type string[]
    local range_text =
        vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
    ---@type string
    local selection = table.concat(range_text, '\n')
    ---@type string
    local selection_in_fences =
        string.format('```%s\n%s\n```', filetype, selection)
    return selection_in_fences
end

--- Get the project root directory of the current file or the given path.
--- ```lua
--- local root_dir = vim.u.utils.get_root_dir()
--- assert(root_dir:match('^%w+://'))
--- ```
---@param path? string Optional path to search, defaults to current file
---@return string
function vim.u.utils.get_root_dir(path)
    path = path or vim.fn.expand('%:p:h')

    -- Try to find root with lspconfig
    local root_dir = vim.lsp.buf.list_workspace_folders()[1]
    if root_dir then
        return root_dir
    end

    -- Fallback to custom git root search
    root_dir = vim.u.git.get_root_dir()
    if root_dir then
        return root_dir
    end

    -- Default to current working dir
    return vim.fn.getcwd()
end

---Get the current visual selection.
---@return string
function vim.u.utils.get_visual_selection()
    local _, lnum_start, col_start = unpack(vim.fn.getpos('v')) -- start of visual selection
    local _, lnum_end, col_end = unpack(vim.fn.getpos('.'))     -- end of visual selection
    local range_text = vim.api.nvim_buf_get_text(
        0,
        lnum_start,
        col_start,
        lnum_end,
        col_end,
        {}
    )
    local selection = table.concat(range_text, '\n')
    return selection
end

---Get the source of a function that is passed in.
---@param func function
---@return table|nil
function vim.u.utils.get_function_source(func)
    ---@type debuginfo
    local info = debug.getinfo(func, 'S')
    if not info.source or info.source:sub(1, 1) ~= '@' then
        return nil
    end

    local path = info.source:sub(2)

    ---@type file*?
    local f, err = assert(io.open(path, 'rb'))
    if not f then
        vim.notify(err, vim.log.levels.ERROR, { title = 'ERROR' })
        return nil
    end
    local first_line
    local lnum = 0
    for line in f:lines() do
        lnum = lnum + 1
        if lnum == info.linedefined then
            first_line = line
            break
        end
    end
    f:close()

    if not first_line then
        return nil
    end

    local tbl = {
        first_line = first_line,
        path = path,
        func_name = first_line:match('function%s+(%w+)') or first_line:match(
            'local%s+(%w+)'
        ) or first_line:match('(%w+)%s*='),
        path_to_parent = path:match('(.*/)'),
    }
    return tbl
end

--- Jump to next line with same indentation level
--- @param down boolean
--- @param ignore string[]
--- @return boolean
function vim.u.utils.jump_to_next_line_with_same_indent(down, ignore)
    local lnum = vim.fn.line('.')
    local max_lines = vim.fn.line('$')
    local target_indent

    local ignore_set = {}
    for _, v in ipairs(ignore) do
        ignore_set[v] = true
    end

    ---@param line_content string
    ---@return number
    local function get_indentation_level(line_content)
        local spaces = line_content:match('^(%s*)')
        return #spaces
    end

    ---@param line_content string
    ---@return boolean
    local function starts_with_ignore(line_content)
        for pattern in pairs(ignore_set) do
            if line_content:match('^%s*' .. pattern .. '%S*') then
                return true
            end
        end
        return false
    end

    local curr_line_content = vim.fn.getline(lnum)

    -- If the current line is empty, try to find the next non-empty line's indentation as the target_indent
    if curr_line_content:match('^%s*$') then
        local temp_lnum = down and (lnum + 1) or (lnum - 1)
        while
            temp_lnum > 0
            and temp_lnum <= max_lines
            and vim.fn.getline(temp_lnum):match('^%s*$')
        do
            temp_lnum = down and (temp_lnum + 1) or (temp_lnum - 1)
        end
        if temp_lnum <= 0 or temp_lnum > max_lines then
            return true -- Reached the top or bottom without finding a non-empty line
        end
        curr_line_content = vim.fn.getline(temp_lnum)
        lnum = temp_lnum
    end

    local first_char_pos = curr_line_content:find('[A-Za-z_]')
    if first_char_pos then
        target_indent = get_indentation_level(curr_line_content)
    else
        return true -- No valid indentation level found in current line
    end

    -- Define the direction for the loop increment
    local increment = down and 1 or -1

    -- Start searching from the next/previous line
    lnum = lnum + increment

    while (not down and lnum > 0) or (down and lnum <= max_lines) do
        local line_content = vim.fn.getline(lnum)
        local new_first_char_pos = line_content:find('[A-Za-z_]')
        if new_first_char_pos then
            local current_indent = get_indentation_level(line_content)
            if
                current_indent == target_indent
                and not starts_with_ignore(line_content)
            then
                vim.api.nvim_win_set_cursor(0, { lnum, new_first_char_pos - 1 })
                break
            end
        end
        lnum = lnum + increment
    end

    return true
end

function P(v)
    local Popup = require('nui.popup')
    local text

    if type(v) == 'function' then
        local tbl = vim.u.utils.get_function_source(v)

        if not tbl then
            vim.notify('Could not get function source', vim.log.levels.ERROR, {
                title = 'ERROR',
            })
            return nil
        end
        require('telescope.builtin').live_grep({
            default_text = tbl.func_name,
            search_dirs = { tbl.path_to_parent },
        })
        return nil
    end
    text = vim.inspect(v)

    local win_config = {
        enter = true,
        relative = 'editor',
        focusable = true,
        border = {
            style = 'rounded',
        },
        position = '50%',
        size = {
            width = '80%',
            height = '90%',
        },
        buf_options = {
            buftype = '',
        },
        win_options = {
            winhighlight = 'Normal:Normal',
            number = true,
        },
    }

    local popup = Popup(win_config)
    popup:mount()
    if text:len() < 10000 then
        local dummy_filename = 'inspect.lua'
        local filetype = 'lua'
        vim.api.nvim_buf_set_name(popup.bufnr, dummy_filename)
        vim.api.nvim_set_option_value(
            'filetype',
            filetype,
            { buf = popup.bufnr }
        )
        vim.api.nvim_set_option_value('buftype', '', { buf = popup.bufnr })
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, true, vim.split(text, '\n'))

    vim.api.nvim_set_option_value('modifiable', false, { buf = popup.bufnr })
    vim.api.nvim_set_option_value('readonly', true, { buf = popup.bufnr })

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'q', function()
        popup:unmount()
    end, opts)

    popup:on('BufLeave', function()
        popup:unmount()
    end)

    return v
end

function R(_package)
    package.loaded[_package] = nil
    return require(_package)
end

function T()
    print(require('nvim-treesitter.ts_utils').get_node_at_cursor():type())
end

--------------------------------------------------------------------------------

---@type table
vim.u.git = {}

--- Sets up global git base variable to HEAD ref
---
---@return nil
vim.u.git.setup = function()
    vim.g.git_base = 'HEAD'
end

--- Checks if the current directory is a git repository
---
--- @return boolean
vim.u.git.is_repo = function()
    vim.fn.system('git -C . rev-parse')
    return vim.v.shell_error == 0
end

--- Get the root directory of the current git repo
--- @return string? root_dir
function vim.u.git.get_root_dir()
    if not vim.u.git.is_repo() then
        return nil
    end

    local output = vim.fn.system('git rev-parse --show-toplevel')
    local root_dir = vim.trim(output)
    if root_dir == '' then
        return nil
    end
    return root_dir
end

--- Sets the git base ref for diffing
---
--- @param base string? The git ref to diff against, defaults to HEAD
function vim.u.git.set_diff_base(base)
    if not base or base == '' then
        base = 'HEAD'
    end

    vim.g.git_base = base

    vim.g.gitgutter_diff_base = vim.g.git_base

    local win = vim.api.nvim_get_current_win()
    vim.cmd([[noautocmd windo GitGutter]])
    vim.api.nvim_set_current_win(win)

    print(string.format('Now diffing against %s', vim.g.git_base))
end

--------------------------------------------------------------------------------

--- @param client lspconfig.Config
--- @param bufnr number
--- @return nil
local on_attach_lsp = function(client, bufnr)
    -- require("lsp-format").on_attach(client)
    --- TODO: Check does support_method exists
    --- @diagnostic disable-next-line: undefined-field
    if client.supports_method('textDocument/inlayHint') then
        require('lsp-inlayhints').on_attach(client, bufnr)
    end
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set(
        'n',
        '<leader>e',
        vim.diagnostic.open_float,
        { desc = 'open diagnostics in float window', noremap = true }
    )
    vim.keymap.set('n', '[d', function()
        -- Check if Trouble is toggled
        if require('trouble').is_open() then
            local trouble_last = require('trouble')._find_last()
            if trouble_last == nil then
                return
            end
            require('trouble').next(trouble_last, {
                skip_groups = true,
                jump = true,
            })
        else
            vim.diagnostic.jump({
                count = -1,
                popup_opts = { border = 'rounded' },
            })
        end
    end, { desc = 'go to previous diagnostic', noremap = true })
    vim.keymap.set('n', ']d', function()
        -- require('trouble').previous({ skip_groups = true, jump = true })
        if require('trouble').is_open() then
            local trouble_last = require('trouble')._find_last()
            if trouble_last == nil then
                return
            end
            require('trouble').prev(trouble_last, {
                skip_groups = true,
                jump = true,
            })
        else
            vim.diagnostic.jump({
                count = 1,
                popup_opts = { border = 'rounded' },
            })
        end
    end, { desc = 'go to next diagnostic', noremap = true })
    vim.keymap.set(
        'n',
        '<leader>q',
        vim.diagnostic.setloclist,
        { desc = 'set loclist', noremap = true }
    )

    vim.keymap.set('n', '<leader>gd', function()
        local current_repo_path = client.root_dir(
            vim.fn.expand('%:p'),
            vim.api.nvim_get_current_buf()
        )
        vim.cmd('cd ' .. current_repo_path)
        local current_search
        local ts_node = vim.treesitter.get_node()
        if ts_node then
            current_search =
                vim.treesitter.get_node_text(ts_node, vim.fn.bufnr())
            if current_search == '' then
                current_search = vim.fn.expand('<cword>')
            end
        else
            current_search = vim.fn.expand('<cword>')
        end
        if type(current_search) == 'string' then
            if string.find(current_search, '\n') then
                return
            end
        end
        require('telescope.builtin').grep_string({ -- use current word under cursor as query
            search_dirs = {
                current_repo_path,
            },
            word_match = '-w',
            default_text = current_search,
            path_display = { 'truncate' },
        })
    end, { desc = 'find definitions', noremap = true })
    vim.keymap.set('v', '<leader>gd', function()
        local current_repo_path =
            require('lspconfig.util').root_pattern('.git')(
                vim.fn.expand('%:p:h')
            )
        vim.cmd('cd ' .. current_repo_path)
        local current_search = vim.fn.getreg('g')
        require('telescope.builtin').grep_string({ -- use current word under cursor as query
            search_dirs = {
                current_repo_path,
            },
            default_text = current_search,
            word_match = '-w',
            path_display = { 'smart' },
            initial_mode = 'normal',
        })
    end, { desc = 'find definitions', noremap = true })

    -- Mapping
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', function()
        -- cd to current file's directory until .git is found
        require('telescope.builtin').lsp_references({
            -- use current word under cursor as query
            default_text = vim.fn.expand('<cword>'),
        })
    end, { desc = 'find references', noremap = true })
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end

--------------------------------------------------------------------------------
--- Lazy loading
--------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if vim.fn.isdirectory(lazypath) == 0 then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        -- '--branch=stable', -- latest stable release
        lazypath,
    })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Provides utility functions for Neovim Lua development
    {
        'nvim-lua/plenary.nvim',
    }, --- Code completion using supermaven AI
    {
        'supermaven-inc/supermaven-nvim',
        opts = {
            keymaps = {
                accept_suggestion = '<CS-j>',
                clear_suggestion = '<CS-k>',
                accept_word = '<CS-y>',
            },
            ignore_filetypes = { cpp = true },
            color = {
                suggestion_color = '#00b7f0',
                cterm = 244,
            },
            log_level = 'off',
            disable_inline_completion = false, -- disables inline completion for use with cmp
            disable_keymaps = false,           -- disables built in keymaps for more manual control
        },
    },
    -- Offers a popup API for Neovim Lua plugins
    {
        'nvim-lua/popup.nvim',
    },
    -- LSP kind icons
    {
        'onsails/lspkind-nvim',
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            local highlight = {
                'RainbowRed',
                'RainbowYellow',
                'RainbowBlue',
                'RainbowOrange',
                'RainbowGreen',
                'RainbowViolet',
                'RainbowCyan',
            }
            local hooks = require('ibl.hooks')
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
                vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
                vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
                vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
                vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
                vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
                vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
            end)

            vim.g.rainbow_delimiters = { highlight = highlight }
            require('ibl').setup({ scope = { highlight = highlight } })

            hooks.register(
                hooks.type.SCOPE_HIGHLIGHT,
                hooks.builtin.scope_highlight_from_extmark
            )
        end,
    },
    {
        'Aasim-A/scrollEOF.nvim',
    },
    {
        'piersolenski/wtf.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
        },
        opts = {
            -- Default AI popup type
            popup_type = 'popup',
            -- An alternative way to set your API key
            openai_api_key = vim.env.OPENAI_API_KEY,
            -- ChatGPT Model
            openai_model_id = 'gpt-4o',
            -- Send code as well as diagnostics
            context = true,
            -- Set your preferred language for the response
            language = 'english',
            -- Any additional instructions
            additional_instructions =
            'I have worked with neovim more than ten years, I know it super well. Start the reply with short neovim random tip to surprise my experience!',
            -- Default search engine, can be overridden by passing an option to WtfSeatch
            search_engine = 'google',
            -- Callbacks
            hooks = {
                request_started = nil,
                request_finished = nil,
            },
            -- Add custom colours
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
    },
    -- Creates a light and configurable status line for Neovim
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'piersolenski/wtf.nvim',
        },
        opts = {
            options = {
                icons_enabled = false,
                theme = 'catppuccin',
                component_separators = { left = '', right = '' },
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
                },
            },
            sections = {
                -- add cwd to lualine
                lualine_a = {
                    'mode',
                },
                -- lualine_b = { function() return vim.fn.getcwd() end, 'branch', 'diff', 'diagnostics' },
                -- lualine_b = { function() return vim.fn.getcwd():gsub(os.getenv('HOME'), '~') end, 'branch', 'diff', 'diagnostics' },
                lualine_c = { { 'filename', path = 4 } },
                lualine_x = {
                    'filetype',
                },
                lualine_y = {},
                lualine_z = {
                    'location',
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = {},
                lualine_y = {
                    'location',
                },
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        },
    },
    { -- This module contains a number of default definitions
        'HiPhish/rainbow-delimiters.nvim',
        url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git',
        config = function()
            local rainbow_delimiters = require('rainbow-delimiters')

            ---@type rainbow_delimiters.config
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                priority = {
                    [''] = 110,
                    lua = 210,
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end,
    },
    -- Fuzzy finder with a rich plugin ecosystem
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            require('user.plugins.telescope')
        end,
    },
    -- Telescope extension for repository management
    {
        'cljoly/telescope-repo.nvim',
    },
    -- Implements a command palette using Telescope
    {
        'LinArcX/telescope-command-palette.nvim',
    },
    -- Allows browsing bookmarks with Telescope
    {
        'dhruvmanila/telescope-bookmarks.nvim',
    },
    -- Provides a file browser for Telescope
    {
        'nvim-telescope/telescope-file-browser.nvim',
    },
    -- Integrates GitHub with Telescope. See: https://github.com/nvim-telescope/telescope-github.nvim
    {
        'nvim-telescope/telescope-github.nvim',
    },
    -- Adds UI selection support for Telescope
    {
        'nvim-telescope/telescope-ui-select.nvim',
    },
    -- Offers FZF sorter for Telescope
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },
    -- Provides Zoxide integration for Telescope
    {
        'jvgrootveld/telescope-zoxide',
    },
    -- Supports frecent files for Telescope
    {
        'nvim-telescope/telescope-frecency.nvim',
    },
    -- Displays color previews for Telescope
    {
        'uga-rosa/ccc.nvim',
        init = function()
            vim.opt.termguicolors = true
        end,
        opts = {
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        },
    },
    -- Enables distraction-free writing mode
    {
        'preservim/vim-pencil',
    },
    -- Allows marking and navigating to files/buffers
    {
        'ThePrimeagen/harpoon',
        config = function()
            local harpoon = require('harpoon')
            local mark = require('harpoon.mark')
            local ui = require('harpoon.ui')
            local term = require('harpoon.term')

            local defaut_opts = {
                global_settings = {
                    save_on_toggle = true,
                    save_on_change = true,
                    enter_on_sendcmd = false,
                    tmux_autoclose_windows = false,
                    excluded_filetypes = {
                        'harpoon',
                    },
                    mark_branch = false,
                    tabline = false,
                    tabline_prefix = '   ',
                    tabline_suffix = '   ',
                },
                menu = {
                    width = vim.api.nvim_win_get_width(0) - 10,
                },
            }

            mark.add_file_and_notify = function()
                mark.add_file()
                vim.notify(
                    'Added: ' .. tostring(vim.fn.expand('%')),
                    vim.log.levels.INFO,
                    {
                        title = 'Harpoon',
                        timeout = 100,
                    }
                )
            end

            ui.on_attach = {}
            local my_weird_keymaps = {
                e = 1,
                a = 2,
                h = 3,
                i = 4,
                s = 5,
                k = 6,
                r = 7,
                c = 8,
                n = 9,
            }

            function ui.on_attach.set_on_keymaps_harpoon_enter()
                local function set_keymap(index, keycode)
                    vim.keymap.set('n', keycode, function()
                        local line_count = vim.api.nvim_buf_line_count(0)
                        local current_line = vim.api.nvim_win_get_cursor(0)[1]
                        if current_line ~= index and index <= line_count then
                            vim.cmd('normal! ' .. index .. 'G')
                        end
                        vim.cmd(
                            'lua require(\'harpoon.ui\').select_menu_item()'
                        )
                        vim.cmd('normal! <CR>')
                    end, {
                        silent = true,
                        buffer = 0,
                        nowait = true,
                    })
                end
                for harpoon_key, index in pairs(my_weird_keymaps) do
                    set_keymap(index, harpoon_key)
                end
            end

            function ui.on_attach.unset_on_keymaps_harpoon_enter()
                local function unset_keymap(key)
                    vim.keymap.del('n', key)
                    -- Check if the keymap is still there
                    if vim.api.nvim_buf_get_keymap(0, 'n')[key] then
                        vim.notify(
                            'Failed to unset keymap: ' .. key,
                            vim.log.levels.ERROR,
                            { title = 'Harpoon' }
                        )
                    end
                end
                for my_key, harpoon_key in pairs(my_weird_keymaps) do
                    unset_keymap(my_key)
                    unset_keymap(harpoon_key)
                end
            end

            vim.api.nvim_create_augroup('Harpoon', { clear = true })

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'harpoon',
                command = 'lua require(\'harpoon.ui\').on_attach.set_on_keymaps_harpoon_enter()',
                group = 'Harpoon',
            })
            -- vim.api.nvim_create_autocmd(
            --         { "BufLeave" },
            --         {
            --                 pattern = "harpoon",
            --                 command = "lua require('harpoon.ui').on_attach.unset_on_keymaps_harpoon_enter()",
            --                 group = "Harpoon"
            --},
            vim.keymap.set(
                'n',
                '<leader>a',
                mark.add_file_and_notify,
                { silent = true, desc = 'add file to harpoon' }
            )
            vim.keymap.set('n', '<leader>j', function()
                ui.toggle_quick_menu()
            end, { silent = true, desc = 'toggle harpoon menu' })
            vim.keymap.set(
                'n',
                '<leader>t',
                term.gotoTerminal,
                { silent = true, desc = 'go to terminal' }
            )
            vim.keymap.set('n', '<C-e>', function()
                ui.nav_file(1)
            end, {
                silent = true,
                desc = 'navigate to harpoon file 1',
            })
            vim.keymap.set('n', '<C-a>', function()
                ui.nav_file(2)
            end, {
                silent = true,
                desc = 'navigate to harpoon file 2',
            })
            vim.keymap.set('n', '<C-h>', function()
                ui.nav_file(3)
            end, {
                silent = true,
                desc = 'navigate to harpoon file 3',
            })
            vim.keymap.set('n', '<C-i>', function()
                ui.nav_file(4)
            end, {
                silent = true,
                desc = 'navigate to harpoon file 4',
            })

            harpoon.setup(defaut_opts)
        end,
        event = 'BufEnter',
    },
    -- Visualizes undo history as a tree
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {
                remap = false,
                silent = true,
            })
        end,
    },
    -- Acts as a Git wrapper for Neovim
    {
        'tpope/vim-fugitive',
    },
    -- Simplifies manipulation of surrounding text
    {
        'tpope/vim-surround',
    },
    -- Allows previewing media files with Telescope
    {
        'nvim-telescope/telescope-media-files.nvim',
    },
    {
        'nvim-telescope/telescope-packer.nvim',
    },
    -- Keeps the cursor centered on the screen
    {
        'arnamak/stay-centered.nvim',
    },
    -- Acts as a snippet engine for Lua
    {
        'L3MON4D3/LuaSnip',
        config = function()
            local ls = require('luasnip')               -- Import the library
            local types = require('luasnip.util.types') -- Import the types table
            ls.setup({
                snip_env = {
                    s = function(...)
                        local snip = ls.s(...)
                        -- we can't just access the global `ls_file_snippets`, since it will be
                        -- resolved in the environment of the scope in which it was defined.
                        table.insert(getfenv(2).ls_file_snippets, snip)
                    end,
                    parse = function(...)
                        local snip = ls.parser.parse_snippet(...)
                        table.insert(getfenv(2).ls_file_snippets, snip)
                    end,
                },
            })

            -- Config
            ------------------------------------------------------------------------------
            ls.config.set_config({
                history = true,                            -- Save snippets history
                updateevents = 'TextChanged,TextChangedI', -- Events that update the snippets

                enable_autosnippets = true,                -- Enable auto snippets

                -- Crazy highlights!
                ext_opts = {
                    [types.choiceNode] = {
                        active = { virt_text = { { 'Choice', 'Comment' } } },
                    },
                    [types.insertNode] = {
                        active = { virt_text = { { 'Insert', 'Comment' } } },
                    },
                    [types.functionNode] = {
                        active = { virt_text = { { 'Function', 'Comment' } } },
                    },
                    [types.snippetNode] = {
                        active = { virt_text = { { 'Snippet', 'Comment' } } },
                    },
                },
            })

            -- Declarations
            ------------------------------------------------------------------------------
            local snippet = ls.s
            -- local snippet_from_nodes = ls.sn
            local t = ls.t
            -- local i = ls.i
            -- local f = ls.f
            -- local c = ls.c
            -- local cond = ls.cond
            -- local dyn = ls.dyn
            -- local l = require('luasnip.extras').lambda
            -- local events = require('luasnip.util.events')

            -- local same = function(index)
            --     return f(function(args)
            --         return args[1]
            --     end, { index })
            -- end
            --
            -- local toexpand_count = 0 -- Count of the number of times the snippet has been expanded

            -- Snippets
            ------------------------------------------------------------------------------
            ls.add_snippets('lua', {
                snippet('date', {
                    t(os.date('%d/%m/%Y')),
                }),
                -- try if else snippet
                ls.parser.parse_snippet(
                    'try',
                    [[
    try {
        $1
    } catch (error) {
        $2
    }
    ]]
                ),
                ls.parser.parse_snippet(
                    'if',
                    [[
    if ($1) {
        $2
    } else {
        $3
    }
    ]]
                ),
                -- if else snippet
                -- to use the snippet, type 'try' and press <c-k> then press <tab> to jump to the next item
            })

            -- Mappings
            ------------------------------------------------------------------------------

            -- <c-k>
            -- will expand the current item or jump to the next one
            vim.keymap.set({ 'i', 's' }, '<C-k>', function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, { silent = true })

            -- <c-j>
            -- will jump to the previous item
            vim.keymap.set({ 'i', 's' }, '<c-j>', function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, { silent = true })

            -- <c-l>
            -- is used to selecting within a list of options
            vim.keymap.set({ 'i', 's' }, '<c-l>', function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true })

            -- <leader><leader> > s
            -- will source my luasnip file again, which will reload all my snippets
            vim.keymap.set({ 'n', 's' }, '<leader><leader> > s', function()
                vim.cmd(
                    'luafile ~/.config/nvim/lua/user/configs/luasnip/init.lua'
                )
                vim.notify(
                    'Snippets reloaded!',
                    vim.log.levels.INFO,
                    { title = 'LuaSnip' }
                )
            end, { silent = true })
        end,
    },
    -- Provides LuaSnip completion source for nvim-cmp
    {
        'saadparwaiz1/cmp_luasnip',
    },
    -- Implements a minimal LSP client for Neovim
    {
        'VonHeikemen/lsp-zero.nvim',
        config = function()
            local lspconfig = require('lspconfig')
            local lsp_zero = require('lsp-zero') -- LSP Zero plugin
            lsp_zero.extend_lspconfig()
            local mason = require('mason')
            mason.setup()
            local lspconfig_mason = require('mason-lspconfig')
            lspconfig_mason.setup()

            -- local available_servers = require('mason-lspconfig').get_available_servers()
            -- for _, server in ipairs(available_servers) do
            --     lsp_zero.default_setup(server)
            -- end

            vim.opt.signcolumn = 'yes'

            -- Bash, Shell, zsh etc
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local bashls = {
                on_attach = on_attach_lsp,
                cmd = { 'bash-language-server', 'start' },
                cmd_env = {
                    GLOB_PATTERN = '*@(.sh|.inc|.bash|.command)',
                },
                filetypes = { 'sh', 'zsh', 'bash', 'shell' },
            }
            lspconfig.bashls.setup(bashls)

            --- Check if spoon is mine by checking author field in init.lua
            ---
            ---@return boolean
            local function is_my_spoon(file_path)
                local function check_pattern(pattern)
                    local command = { 'grep', '-q', '-E', pattern, file_path }
                    return vim.fn.systemlist(command)
                end

                local username = vim.fn.system('whoami'):gsub('[\n\r]', '')
                local fullname = vim.fn
                    .system('git config --get user.name')
                    :gsub('[\n\r]', '')
                local email = vim.fn
                    .system('git config --get user.email')
                    :gsub('[\n\r]', '')

                -- Check for author
                for _, identifier in ipairs({ username, fullname, email }) do
                    local pattern = '^\\w+\\.author\\s*=\\s*.*'
                        .. identifier
                        .. '.*'
                    if #check_pattern(pattern) > 0 then
                        return true -- Authored by you
                    end
                end

                -- If the spoonPath contains your username, it's likely not authored by you.
                local exclude_pattern = 'spoonPath = ".*' .. username .. '.*"'
                if #check_pattern(exclude_pattern) > 0 then
                    return false -- Contains specific spoonPath, but not authored by you.
                end

                return false -- Default to not yours if no matching conditions.
            end

            --- Filter out diagnostics from spoons that are not authored by me.
            local function filter_spoon_diagnostics(err, result, ctx, cfg)
                -- Filter out diagnostics from '.*\.spoon/*'
                local spoon_path_pattern = '^file.*%.spoon.*$'
                if result.uri:match(spoon_path_pattern) then
                    if not result.uri:match('^.*init%.lua$') then
                        return
                    end
                    local file_path = vim.uri_to_fname(result.uri)
                    if is_my_spoon(file_path) then
                        return vim.lsp.diagnostic.on_publish_diagnostics(
                            err,
                            result,
                            ctx,
                            cfg
                        )
                    end
                    return
                end
                return vim.lsp.diagnostic.on_publish_diagnostics(
                    err,
                    result,
                    ctx,
                    cfg
                )
            end

            --- Get the lua version of the current buffer
            ---
            ---@return string
            local function get_lua_version()
                local buffer_path = tostring(vim.fn.expand('%:p:h'))
                local nvim_path = tostring(vim.fn.stdpath('config'))
                local is_neovim = string.find(buffer_path, nvim_path) and true
                    or false
                local is_hammerspoon = string.find(buffer_path, 'hammerspoon')
                    and true
                    or false
                if is_neovim then
                    return 'LuaJIT'
                elseif is_hammerspoon then
                    local lua_version =
                        vim.fn.system('hs -c _VERSION'):gsub('[\n\r]', '')
                    if lua_version:match('^error') then
                        vim.notify(lua_version, vim.log.levels.ERROR, {
                            title = 'Neovim',
                        })
                    end
                    return lua_version
                end
                return 'LuaJIT'
            end

            ---Check if the current repo has a .luarc.json or .luarc.jsonc file
            ---
            ---@return boolean
            -- local function is_luarc_exists(path)
            --     local exists = false
            --     if vim.fn.filereadable(path .. '/.luarc.json') == 1 then
            --         exists = true
            --     elseif vim.fn.filereadable(path .. '/.luarc.jsonc') == 1 then
            --         exists = true
            --     end
            --     return exists
            -- end

            --- On attach function for lua language server
            --- This function is used to set up the `lua` language server
            ---@param client vim.lsp.Client
            local lua_on_attach = function(client, _)
                local root_dir = client.config.root_dir
                    or vim.u.utils.get_root_dir()

                local lua_version = get_lua_version()
                local homebrew_prefix =
                    vim.fn.system('brew --prefix'):gsub('[\n\r]', '')

                local lua_path = {
                    '?.lua',
                    '?/init.lua',
                    vim.fn.expand(
                        homebrew_prefix
                        .. '/lib/luarocks/rocks-5.4/luarocks/share/lua/5.4/?.lua'
                    ),
                }

                local user_settings = {
                    Lua = {},
                }
                local lua_client = user_settings.Lua

                lua_client.runtime = {
                    version = lua_version,
                    path = lua_path,
                }
                lua_client.completion = {
                    displayContext = 1,
                }

                lua_client.diagnostics = {
                    enable = true,
                    globals = {
                        'vim',
                        'use',
                        'hs',
                        'describe',
                        'it',
                        'before_each',
                        'after_each',
                    },
                    ['codestyle-check'] = 'Any',
                    libraryFiles = 'Enable',
                }

                local runtime = vim.api.nvim_get_runtime_file('', true)
                local library = {}
                for _, path in ipairs(runtime) do
                    table.insert(library, path .. '/lua')
                end

                lua_client.workspace = {
                    checkThirdParty = true,
                    library = library,
                }
                lua_client.format = {
                    enable = false,
                }
                lua_client.format.defaultConfig = {
                    indent_style = 'space',
                    indent_size = 2,
                }

                -- If current repo is hammerspoon config
                -- Add hammerspoon annotations to the workspace library
                local is_hammerspoon = root_dir:match('hammerspoon')
                if is_hammerspoon then
                    local hammerspoon_path =
                        vim.fn.expand('~/.config/hammerspoon')
                    local annotations_path = hammerspoon_path
                        .. '/Spoons/EmmyLua.spoon/annotations'
                    table.insert(lua_client.workspace.library, annotations_path)
                end

                local settings = vim.tbl_deep_extend(
                    'force',
                    client.config.settings,
                    user_settings
                )
                if not settings then
                    error('Failed to set up `lua language server`')
                end

                client.config.settings = settings
                client.notify('workspace/didChangeConfiguration', {
                    settings = settings,
                })
                client.config.on_attach = on_attach_lsp

                -- Make autogroups for lsp_lua
                vim.api.nvim_create_augroup('LspLua', { clear = true })

                vim.api.nvim_create_autocmd('InsertLeave', {
                    callback = function()
                        local line = vim.api.nvim_win_get_cursor(0)[1]
                        if line ~= vim.b.last_line then
                            vim.cmd('norm! zz')
                            vim.b.last_line = line
                            if vim.fn.getline(line) == '' then
                                local column = vim.fn.getcurpos()[5]
                                vim.fn.cursor({ line, column })
                            end
                        end
                    end,
                    group = 'LspLua',
                    pattern = 'lua',
                })

                return true
            end

            -- Lua
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local lua_ls = {
                on_attach = lua_on_attach,
                handlers = {
                    ['textDocument/publishDiagnostics'] = filter_spoon_diagnostics,
                },
            }
            lspconfig.lua_ls.setup(lua_ls)

            -- Typescript
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local ts_ls = {
                -- settings = {
                --         typescript = ts_ls_config,
                --         javascript = ts_ls_config,
                -- },
                on_init = function(client)
                    local ts_ls_config = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    }
                    client.config.settings =
                        vim.tbl_deep_extend('force', client.config.settings, {
                            typescript = ts_ls_config,
                            javascript = ts_ls_config,
                        })
                    client.notify(
                        'workspace/didChangeConfiguration',
                        { settings = client.config.settings }
                    )
                end,
            }
            -- Configuration to make lsp-inlayhints.nvim work with TypeScript
            lspconfig.ts_ls.setup(ts_ls)

            -- Svelte
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local svelte = {
                -- cmd = { "svelteserver", "--stdio" },
                -- filetypes = { "svelte" },
                -- root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
                -- settings = {},
                -- })
                on_init = function(client)
                    local user_settings = {
                        svelte = {
                            plugin = {
                                html = {
                                    completions = {
                                        enable = true,
                                        emmet = true,
                                    },
                                },
                            },
                        },
                    }
                    client.config.settings = vim.tbl_deep_extend(
                        'force',
                        client.config.settings,
                        user_settings
                    )
                    client.notify(
                        'workspace/didChangeConfiguration',
                        { settings = client.config.settings }
                    )
                end,
            }
            lspconfig.svelte.setup(svelte)

            -- Rust
            -------------------------------------------------------------------------------
            ---@type lspconfig.Config
            local rust_analyzer = {
                on_attach = function(client)
                    local on_attach_opts = function(c, bufnr)
                        require('lsp-format').on_attach(c)
                        vim.api.nvim_create_augroup(
                            'DiagnosicFloat',
                            { clear = true }
                        )
                        vim.api.nvim_create_autocmd('CursorHold', {
                            callback = function()
                                vim.diagnostic.open_float(nil, {})
                            end,
                            group = 'DiagnosicFloat',
                        })
                        vim.keymap.set(
                            'n',
                            '<C-space>',
                            require('rust-tools').hover_actions.hover_actions,
                            { buffer = bufnr }
                        )
                        vim.keymap.set(
                            'n',
                            '<Leader>ga',
                            require('rust-tools').code_action_group.code_action_group,
                            { buffer = bufnr }
                        )
                    end
                    local user_settings = {
                        ['rust-analyzer'] = {
                            on_attach = on_attach_opts,
                            assist = {
                                importMergeBehaviour = 'full', -- this does next: use existing import if possible, otherwise add new import
                            },
                            callInfo = {
                                full = true,
                            },
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                    -- allFeatures = true,
                                },
                                loadOutDirsFromCheck = true,
                            },
                            checkOnSave = {
                                allFeatures = true,
                            },
                            procMacro = {
                                enable = true,
                            },
                            diagnostics = {
                                enable = true,
                                disabled = {
                                    'macro-error',
                                    'unresolved-proc-macro',
                                },
                                enableExperimental = true,
                            },
                        },
                    }
                    client.config.settings = vim.tbl_deep_extend(
                        'force',
                        client.config.settings,
                        user_settings
                    )
                    --         dap = {
                    --                 adapter = {
                    --                         type = "executable",
                    --                         command = "lldb-vscode-10",
                    --                         name = "rt_lldb",
                    --                 },
                    --         },
                    client.notify(
                        'workspace/didChangeConfiguration',
                        { settings = client.config.settings }
                    )
                end,
            }
            lspconfig.rust_analyzer.setup(rust_analyzer)

            -- Python
            -------------------------------------------------------------------------------
            lspconfig.ruff_lsp.setup({
                on_attach = require('lsp-format').on_attach,
                init_options = {
                    settings = {
                        -- Any extra CLI arguments for `ruff` go here.
                        args = {},
                        fixAll = true,
                        interpreter = {
                            properties = {
                                InterpreterPath = vim.fn.exepath('python3'),
                                -- InterpreterPath = '/usr/bin/python3',
                                -- InterpreterPath = '/usr/local/bin/python3',
                            },
                        },
                    },
                },
            })

            --- LSP Status
            local lsp_status = require('lsp-status')
            lsp_status.register_progress()
            lsp_status.config = {
                select_symbol = function(cursor_pos, symbol)
                    if symbol.valueRange then
                        local value_range = {
                            ['start'] = {
                                character = 0,
                                line = vim.fn.byte2line(symbol.valueRange[1]),
                            },
                            ['end'] = {
                                character = 0,
                                line = vim.fn.byte2line(symbol.valueRange[2]),
                            },
                        }
                        return require('lsp-status.util').in_range(
                            cursor_pos,
                            value_range
                        )
                    end
                end,
            }

            -- -- local function filter_spoon_diagnostics(err, result, ctx, config)
            -- --         -- Filter out diagnostics from '.*\.spoon/*'
            -- --         local spoon_path_pattern = '^file.*%.spoon.*$'
            -- --         if result.uri:match(spoon_path_pattern) then
            -- --                 if not result.uri:match('^.*init%.lua$') then
            -- --                         return
            -- --                 end
            -- --                 local file_path = vim.uri_to_fname(result.uri)
            -- --                 if is_my_spoon(file_path) then
            -- --                         return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            -- --                 end
            -- --                 return
            -- --         end
            -- --         return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            -- -- end
            -- --
            -- local function custom_publish_diagnostics(err, result, ctx, config)
            --         local pattern = ".*%.trash/.*"
            --         print("err: ", err)
            --         print("result: ", vim.inspect.inspect(result))
            --         print("ctx: ", vim.inspect.inspect(ctx))
            --         print("config: ", vim.inspect.inspect(config))
            --         P(result)
            --         P(ctx)
            --         if result.uri == type("string") and result.uri:match(pattern) then
            --                 result.diagnostics = vim.tbl_filter(function(diagnostic)
            --                         -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
            --                         return not string.find(diagnostic.source or "", "%.trash/")
            --                 end, result.diagnostics)
            --         end
            --         -- if result.uri:match(pattern) then
            --         --         result.diagnostics = vim.tbl_filter(function(diagnostic)
            --         --                 -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
            --         --                 return not string.find(diagnostic.source or "", "%.trash/")
            --         --         end, result.diagnostics)
            --         -- end
            --
            --         return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            --         --
            --         --         result.diagnostics = vim.tbl_filter(function(diagnostic)
            --         --                 -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
            --         --                 return not string.find(diagnostic.source or "", "%.trash/")
            --         --         end, result.diagnostics)
            --         -- end
            --         -- -- Call the default handler with the filtered diagnostics
            --         -- vim.lsp.diagnostic.on_publish_diagnostics(err, result, { client_id = client_id, bufnr = bufnr }, config)
            -- end

            local function filter_trash_notes(err, result, ctx, config)
                local pattern = '.*%.trash/.*'
                if result.uri:match(pattern) then
                    result.diagnostics = vim.tbl_filter(function(diagnostic)
                        -- Check if the diagnostic source file does NOT contain the pattern ".trash/"
                        return not string.find(
                            diagnostic.source or '',
                            '%.trash/'
                        )
                    end, result.diagnostics)
                else
                    vim.lsp.diagnostic.on_publish_diagnostics(
                        err,
                        result,
                        ctx,
                        config
                    )
                end
            end

            lspconfig.marksman.setup({
                on_attach = on_attach_lsp,
                handlers = {
                    ['textDocument/publishDiagnostics'] = filter_trash_notes,
                },
            })

            -- C
            -------------------------------------------------------------------------------
            lspconfig.clangd.setup({
                on_attach = on_attach_lsp,
                handlers = {
                    ['textDocument/publishDiagnostics'] = filter_trash_notes,
                },
            })

            --
            -- if not lsp_configurations.obsidian then
            --         lsp_configurations.obsidian = {
            --                 default_config = {
            --                         autostart = true,
            --                         cmd = { "npx", "obsidian-lsp", "--", "--stdio" },
            --                         single_file_support = false,
            --                         root_dir = require('lspconfig.util').root_pattern('.obsidian'),
            --                         handlers = {
            --                                 --         --- Disable lsp for files in ~/knowledge/\..*/*
            --                                 --         ["textDocument/reference"] = filter_trash_notes,
            --                                 --         ["textDocument/definition"] = filter_trash_notes,
            --                                 --         ["textDocument/documentSymbol"] = filter_trash_notes,
            --                                 --         ["textDocument/hover"] = filter_trash_notes,
            --                                 ["workspace/diagnostics"] = vim.lsp.with(
            --                                         filter_trash_notes, {}),
            --                         },
            --                 },
            --         }
            -- end
            -- lspconfig.obsidian.setup {}

            -- Autocommands
            lsp_zero.on_attach(on_attach_lsp)
        end,
        branch = 'v3.x',
    },
    -- Offers a collection of LSP configurations
    {
        'neovim/nvim-lspconfig',
    },
    -- Provides inlay hints for LSP
    {
        'lvimuser/lsp-inlayhints.nvim',
        opts = {},
        lazy = true,
        init = function()
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
    -- Formats code using LSP
    {
        'lukas-reineke/lsp-format.nvim',
    },
    -- Displays status messages for LSP
    {
        'nvim-lua/lsp-status.nvim',
    },
    -- Manages projects and sessions
    {
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
    {
        'justinsgithub/wezterm-types',
        lazy = true,
    },
    {
        'LuaCATS/luassert',
        name = 'luassert-types',
        lazy = true,
    },
    {
        'LuaCATS/busted',
        name = 'busted-types',
        lazy = true,
    },
    -- LSP Plugins
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            debug = true,
            library = {
                { path = 'luvit-meta/library',     words = { 'vim%.uv' } },
                { path = 'wezterm-types',          mods = { 'wezterm' } },
                { path = 'luassert-types/library', words = { 'assert' } },
                { path = 'busted-types/library',   words = { 'describe' } },
            },
        },
    },
    { 'Bilal2453/luvit-meta', lazy = true },
    -- Provides LSP configuration for Mason
    {
        'williamboman/mason-lspconfig.nvim',
    },
    -- Acts as an autocomplete framework for Neovim
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            ---@class cmp.ConfigSchema
            local opts = {}

            opts.snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            }

            opts.style = {
                scrollbar = '║',
                border = vim.u.styles.borders.solid,
            }

            opts.formatting = {
                expandable_indicator = false,
                fields = { 'abbr', 'kind', 'menu' },
                ---@param entry cmp.Entry
                ---@param item vim.CompletedItem
                format = function(entry, item)
                    if not item.kind then
                        item.kind = 'Unknown'
                    end
                    item.menu_hl_group = 'CmpItemKind' .. item.kind
                    local menu_icon = {
                        cody = '[Cody]',
                        copilot = '[Copilot]',
                        nvim_lsp = '[LSP]',
                        nvim_lua = '[Lua]',
                        buffer = '[Buf]',
                        luasnip = '[Snip]',
                        path = '[Path]',
                        neorg = '[Neorg]',
                        vault_tag = '[Tag]',
                        vault_date = '[Date]',
                    }
                    item.menu = menu_icon[entry.source.name]
                    if item.kind == 'Text' then
                        item.kind = ''
                    end
                    return item
                end,
            }
            opts.window = {
                completion = {
                    -- border = { "", "", "", "│", "╯", "─", "╰", "│" },
                    -- square
                    border = { '', '', '', '', '', '', '', '┃' }, -- or bolder border like:
                    zindex = 50,
                    col_offset = 0,
                    side_padding = 0,
                    scrollbar = true,
                    scrolloff = 999,
                    winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:CmpSelection,Search:None',
                    autocomplete = {
                        require('cmp.types').cmp.TriggerEvent.InsertEnter,
                        require('cmp.types').cmp.TriggerEvent.TextChanged,
                    },
                },
                documentation = {
                    border = { '', '', '', '║', '', '', '', '' },
                    side_padding = 16,
                    col_offset = 4,
                    max_width = 0,
                    max_height = 0,
                    winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:CmpSelection,Search:None',
                },
            }
            opts.ghost_text = {
                enabled = false,
            }
            opts.experimental = {
                ghost_text = false,
            }
            opts.view = {
                entries = { name = 'custom', selection_order = 'near_cursor' },
                docs = {
                    auto_open = true,
                },
            }
            opts.sources = {
                { name = 'path' },
                { name = 'cody' },
                { name = 'copilot' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'nvim_lua' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'neorg' },
                { name = 'vault_tag' },
                { name = 'vault_date' },
            }
            opts.sorting = {
                priority_weight = 2,
                comparators = {
                    -- order matters here
                    cmp.config.compare.exact,
                    cmp.config.compare.offset,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            }
            opts.preselect = cmp.PreselectMode.Item

            cmp.setup(opts)
            cmp.setup.filetype({ 'TelescopePrompt' }, opts)

            --set max height of items
            vim.cmd([[ set pumheight=20 ]])
            vim.api.nvim_set_hl(0, 'CmpItemKindCody', { fg = 'Red' })

            -- `:` cmdline setup.
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' },
                        },
                    },
                }),
            })
            -- `/` cmdline setup.
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })
            cmp.setup.cmdline('?', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })
            cmp.setup.cmdline('!', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })
            local copilot_suggestion = require('copilot.suggestion')
            -- local supermaven_suggestion = require("supermaven")

            -- local luasnip = require('luasnip')
            vim.keymap.set('i', '<C-y>', function(fallback)
                if copilot_suggestion.is_visible() then
                    copilot_suggestion.accept_word()
                elseif cmp.visible() then
                    cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = select,
                    })()
                    -- elseif luasnip.expandable() then
                    --   luasnip.expand()
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'confirm completion with C-y(es)',
            })

            -- Accept line
            vim.keymap.set('i', '<C-c>', function()
                if copilot_suggestion.is_visible() then
                    copilot_suggestion.accept_line()
                end
            end, {
                silent = true,
                desc = 'copilot: accept line',
            })

            -- Accept whole copilot suggestion
            vim.keymap.set('i', '<C-j>', function()
                local copilot = copilot_suggestion
                if copilot.is_visible() then
                    copilot.accept()
                end
            end, {
                silent = true,
                desc = 'copilot: accept whole suggestion',
            })

            -- Confirm Complition with C-y(es) in command mode
            vim.keymap.set('c', '<C-y>', function()
                if cmp.visible() then
                    cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = select,
                    })()
                end
            end, {
                silent = true,
                desc = 'confirm completion with C-y(es)',
            })

            vim.keymap.set('!', '<C-y>', function()
                if cmp.visible() then
                    cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = select,
                    })()
                end
            end, {
                silent = true,
                desc = 'confirm completion with C-y(es)',
            })

            -- Select Next Item with C-n(ext)
            vim.keymap.set('i', '<C-n>', function(fallback)
                if copilot_suggestion.is_visible() then
                    copilot_suggestion.next()
                elseif cmp.visible() then
                    cmp.select_next_item()
                    -- elseif luasnip.expandable() then
                    --   luasnip.jump(1)
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'select next item with C-n(ext)',
            })

            vim.keymap.set('c', '<C-n>', function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                    -- elseif luasnip.expandable() then
                    --   luasnip.jump(1)
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'select next item with C-n(ext)',
            })

            vim.keymap.set('!', '<C-n>', function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                    -- elseif luasnip.expandable() then
                    --   luasnip.jump(1)
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'select next item with C-n(ext)',
            })

            -- Select Previous Item with C-p(revious)
            vim.keymap.set('i', '<C-p>', function(fallback)
                if copilot_suggestion.is_visible() then
                    copilot_suggestion.prev()
                elseif cmp.visible() then
                    cmp.select_prev_item()
                    -- elseif luasnip.jumpable(-1) then
                    --   luasnip.jump(-1)
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'select previous item with C-p(revious)',
            })

            vim.keymap.set('!', '<C-p>', function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                    -- elseif luasnip.expandable() then
                    --   luasnip.jump(-1)
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'select next item with C-n(ext)',
            })

            -- Scroll documentation / diagnostic preview C-u(p)
            vim.keymap.set('i', '<C-u>', function(fallback)
                if cmp.visible() then
                    cmp.scroll_docs(-4)
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'scroll documentation / diagnostic preview up in insert mode',
            })

            -- Scroll documentation / diagnostic preview C-d(own)
            vim.keymap.set('i', '<C-d>', function(fallback)
                if cmp.visible() then
                    cmp.scroll_docs(4)
                else
                    fallback()
                end
            end, {
                silent = true,
                desc = 'scroll documentation / diagnostic preview down in insert mode',
            })
        end,
    },
    -- Provides LSP source for nvim-cmp
    {
        'hrsh7th/cmp-nvim-lsp',
    },
    -- Offers signature help for LSP completion
    {
        'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    -- Adds Neovim Lua source for nvim-cmp
    {
        'hrsh7th/cmp-nvim-lua',
    },
    -- Integrates Vsnip source with nvim-cmp
    {
        'hrsh7th/cmp-vsnip',
    },
    -- Supplies file path source for nvim-cmp
    {
        'hrsh7th/cmp-path',
    },
    -- Includes buffer source for nvim-cmp
    {
        'hrsh7th/cmp-buffer',
    },
    -- Offers LuaSnip source for nvim-cmp
    -- {
    --   'saadparwaiz1/cmp_luasnip',
    --},
    -- Provides cmdline source for nvim-cmp
    {
        'hrsh7th/cmp-cmdline',
    },
    -- Displays icons on completions
    {
        'onsails/lspkind-nvim',
    },
    -- Enhances sorting for cmp
    {
        'lukas-reineke/cmp-under-comparator',
    },
    -- LSP client for Obsidian
    {
        'gw31415/obsidian-lsp',
    },
    -- Provides core Treesitter functionality
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        opts = {
            -- A list of parser names, or "all"
            ensure_installed = {
                'javascript',
                'typescript',
                'markdown',
                'c',
                'lua',
                'rust',
                'python',
                'bash',
                'regex',
                'json',
                'yaml',
                'toml',
                'html',
                'css',
                'clojure',
                'go',
                'sxhkdrc',
                'comment',
                'svelte',
                'teal',
            },
            markid = {
                enable = true,
                -- disable = { "c", "rust" },
            },
            sync_install = true,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
                language = {
                    dataviewjs = 'javascript',
                },
            },
            rainbow = {
                enable = true,
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = nil, -- Do not enable for files with more than n lines, int
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']]'] = {
                            query = '@class.outer',
                            desc = 'Next class start',
                        },
                        [']o'] = '@loop.*',
                        [']s'] = {
                            query = '@scope',
                            query_group = 'locals',
                            desc = 'Next scope',
                        },
                        [']z'] = {
                            query = '@fold',
                            query_group = 'folds',
                            desc = 'Next fold',
                        },
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[['] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                },
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = {
                            query = '@class.inner',
                            desc = 'Select inner part of a class region',
                        },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    include_surrounding_whitespace = true,
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
            },
            --- playground
            playground = {
                enable = true,
                disable = {},
                updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            },
        },
    },
    -- Enables refactoring using Treesitter
    {
        'nvim-treesitter/nvim-treesitter-refactor',
    },
    -- Supports AppleScript syntax highlighting
    {
        'vim-scripts/applescript.vim',
    },
    -- Creates colorful brackets using Treesitter
    -- { 'p00f/nvim-ts-rainbow' }, TODO: Find alternative
    -- Acts as a Treesitter playground for Neovim
    {
        'nvim-treesitter/playground',
    },
    -- Provides text objects using Treesitter
    -- FIXME: This plugin is broken
    -- use({
    --     "nvim-treesitter/nvim-treesitter-textobjects",
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --},
    -- Integrates a debugger with Neovim
    {
        'puremourning/vimspector',
        init = function()
            vim.cmd([[
            let g:vimspector_sidebar_width = 85
            let g:vimspector_bottombar_height = 15
            let g:vimspector_terminal_maxwidth = 70
            ]])
        end,
    },
    -- Acts as a commenting plugin
    {
        'numToStr/Comment.nvim',
    },
    -- Provides a text alignment plugin
    {
        'godlygeek/tabular',
    },
    -- Highlights matching text under the cursor
    {
        'RRethy/vim-illuminate',
    },
    -- Manages the clipboard for Neovim
    {
        'AckslD/nvim-neoclip.lua',
    },
    -- Enhances word motions
    {
        'chaoren/vim-wordmotion',
    },
    -- Allows easy text case changes
    {
        'johmsalas/text-case.nvim',
    },
    -- Acts as a key binding helper
    {
        -- [WhichKey](https://github.com/folke/which-key.nvim)
        'folke/which-key.nvim',
        init = function()
            vim.g.timeout = true
            vim.o.timeoutlen = 50
            vim.o.ttimeoutlen = 50
        end,
    },
    -- Adds core Copilot integration
    {
        'zbirenbaum/copilot.lua',
        event = 'VimEnter',
        init = function()
            vim.cmd([[highlight CopilotSuggestion guifg=#408500 gui=italic]])
        end,
        opts = {
            panel = {
                enabled = false,
                auto_refresh = true,
                keymap = {
                    jump_prev = '<M-p>',
                    jump_next = '<M-n>',
                    open = '<M-CR>',
                },
                layout = {
                    position = 'right', -- | top | left | right
                    ratio = 0.4,
                },
            },
            suggestion = {
                enabled = false,
                auto_trigger = true,
                debounce = 0,
            },
            -- Allow to be enabled in all filetypes
            filetypes = {
                ['*'] = true,
                -- markdown = function()
                --     -- Disable for markdown files if 'example_contained_name' is in the path (case insensitive)
                --     local filename = vim.fn.expand("%:p")
                --     if filename and type(filename) == "string" then
                --         filename:lower()
                --     end
                --     if filename == "" then
                --         return true
                --     end
                --     local match = string.match(filename, "example_contained_name")
                --     if match then
                --         return false
                --     end
                --     return true
                -- end,
            },
            copilot_node_command = 'node', -- Node.js version must be > 16.x
            server_opts_overrides = {},
        },
    },
    {
        'zbirenbaum/copilot-cmp',
        config = function()
            require('copilot_cmp').setup()
        end,
    },
    {
        'jonahgoldwastaken/copilot-status.nvim',
        event = 'BufReadPost',
    },
    -- Neovim client for Language Server Protocol
    {
        'catppuccin/nvim',
        config = function()
            local gradient = require('gradient')
            local catppuccin = require('catppuccin')
            local latte = require('catppuccin.palettes').get_palette('latte')

            local black = '#000000'
            -- local raw_blue = '#5ba2b0'
            local red = '#e1291f'
            local pink = '#e24da1'
            local blue = gradient.from_stops(8, '#3061a6', '#b9b952')[2]
            local peach = '#e04d24'
            local maroon = '#BD6F3E'
            local yellow = '#f0a44b'
            local green = '#a9983e'
            local sky = '#fbe9e2'
            local sapphire = '#89B482'
            local mauve = '#91933f'
            local lavender = '#c28d3b'
            -- local text = "#b99d8a"
            local text = '#a59081'
            local subtext1 = '#BDAE8B'
            local subtext0 = '#A69372'
            local overlay2 = '#8C7A58'
            local overlay1 = '#735F3F'
            local overlay0 = '#958272'
            local surface2 = '#1f2121'
            local surface1 = '#171819'
            local surface0 = '#0e0f10'
            local light_blue = '#4087f5'
            -- local base = gradient.from_stops(32, "#030300", light_blue)[2]
            local base = '#060300'
            local mantle = '#000000'
            local crust = '#1E1F1F'
            --- @diagnostic disable-next-line: unused-local
            local emerald = '#a4d97c'

            -- Highlighting
            --- @diagnostic disable-next-line: unused-local
            local bg_diagnostic_unnecessary = overlay1
            -- Comment
            local fg_comment = gradient.from_stops(11, black, text)[6]
            local fg_comment_documentation =
                gradient.from_stops(6, fg_comment, green)[3]

            -- Conditional
            local fg_conditional = gradient.from_stops(8, yellow, red)[3]
            local fg_diagnostic_unnecessary =
                gradient.from_stops(8, text, surface0)[6]
            local fg_number = gradient.from_stops(8, yellow, pink)[7]
            local fg_parameter = gradient.from_stops(6, red, fg_comment)[3]
            local fg_typmod_keyword_documentation =
                gradient.from_stops(9, sky, peach)[8]
            fg_typmod_keyword_documentation = gradient.from_stops(
                8,
                fg_typmod_keyword_documentation,
                black
            )[5]
            local fg_type_type_lua = gradient.from_stops(10, yellow, black)[6]

            -- Function
            local Function = gradient.from_stops(16, yellow, light_blue)
            if Function == nil then
                return
            end
            local fg_function_call = Function[12]
            local fg_function_builin =
                gradient.from_stops(6, Function[12], pink)[5]
            -- local fg_keyword_function = '#a93e57'

            local fg_boolean = fg_number

            local fg_property = lavender
            local fg_variable_builtin =
                gradient.from_stops(5, fg_function_builin, fg_property)[2]

            ---@diagnostic disable-next-line: unused-local
            local fg_preproc = gradient.from_stops(8, red, '#FFFFFF')[4]
            -- local fg_rainbowcol3 = gradient.from_stops(8, red, yellow)[4]
            -- dynamicly assign colors
            -- local fg_rainbowcolor = "fg_rainbowcol" .. reneat % 8

            ---@diagnostic disable-next-line: unused-local
            local fg_repeat =
                gradient.from_stops(8, fg_conditional, fg_number)[6]
            local fg_keyword_operator =
                gradient.from_stops(8, fg_conditional, red)[6]

            ---@diagnostic disable-next-line: unused-local
            local fg_macro = gradient.from_stops(8, mauve, pink)[6]

            local fg_character = gradient.from_stops(8, pink, '#FFFFFF')[5]

            local fg_copilot_annotation =
                gradient.from_stops(8, fg_comment, mauve)[5]

            -- attach_rainbow_colors()

            ---@type { [string]: vim.api.keyset.highlight }
            local hl = {}

            hl.Boolean = { fg = fg_boolean }
            hl.Character = { fg = fg_character }
            hl.Comment = { fg = fg_comment }
            hl.Conditional = { fg = fg_conditional }
            hl['@lsp.typemod.keyword.controlFlow.rust'] =
            { fg = fg_conditional }
            hl['@keyword.return'] = { fg = fg_conditional }
            hl.CopilotAnnotation = { fg = fg_copilot_annotation }
            hl.DiagnosticUnnecessary = { fg = fg_diagnostic_unnecessary }
            hl.FloatBorder = { fg = lavender }
            hl['@function.builtin'] = { fg = fg_function_builin }
            hl['@function.call'] = { fg = fg_function_call }
            hl['@lsp.type.function.call.c'] = { fg = fg_function_call }
            hl.Function = { fg = fg_function_call }
            hl.Keyword = { fg = mauve }
            hl['@keyword.operator'] = { fg = fg_keyword_operator }
            hl['@lsp.type.keyword.lua'] =
            { fg = fg_typmod_keyword_documentation }
            hl.Macro = { fg = fg_macro }
            hl.Number = { fg = fg_number }
            hl['@parameter'] = { fg = fg_parameter }
            hl['@property'] = { fg = fg_property }
            hl.Repeat = { fg = fg_repeat }
            hl['@lsp.type.type.lua'] = { fg = fg_type_type_lua }
            hl['@typmod.keyword.documentation'] =
            { fg = fg_typmod_keyword_documentation }
            hl['@variable.builtin'] = { fg = fg_variable_builtin }
            hl['@comment.documentation'] = { fg = fg_comment_documentation }
            hl.LspInlayHint = { fg = '#2a5175', bg = 'NONE' }
            -- vim.cmd("hi IlluminatedWordRead guibg=#263341")
            -- vim.cmd("hi IlluminatedWordWrite guibg=" .. latte.flamingo)
            -- vim.cmd("hi IlluminatedWordCurWord guifg=#ffe8e8 guibg=" .. latte.flamingo)
            hl.IlluminatedWordRead = { bg = '#263341' }
            hl.IlluminatedWordWrite = { bg = latte.flamingo }
            hl.IlluminatedWordCurWord = { fg = '#ffe8e8', bg = latte.flamingo }
            hl.CmpSelection = { bg = '#26336c' }

            local opts = {
                integrations = {
                    harpoon = true,
                    cmp = true,
                    markdown = true,
                    telescope = {
                        enabled = true,
                    },
                },
                background = {
                    light = 'latte',
                    dark = 'mocha',
                },
                color_overrides = {
                    mocha = {
                        -- blue = '#5ba2b0', -- function call
                        blue = blue,         -- function call
                        peach = peach,       -- self
                        maroon = maroon,     -- bools, calls
                        red = red,
                        yellow = yellow,     -- types, structs, classes
                        green = green,       -- strings
                        sky = sky,           -- operator, #, +, ==, etc
                        sapphire = sapphire,
                        mauve = mauve,       -- function call
                        lavender = lavender, -- types, structs, classes
                        text = text,
                        subtext1 = subtext1,
                        subtext0 = subtext0,
                        overlay2 = overlay2,
                        overlay1 = overlay1,
                        overlay0 = overlay0,
                        surface2 = surface2,
                        surface1 = surface1,
                        surface0 = surface0,
                        base = base,
                        mantle = mantle,
                        crust = crust,
                    },
                },
                styles = {
                    comments = { 'italic' },
                    conditionals = {},
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                transparent_background = false,
                show_end_of_buffer = true,
            }

            opts.custom_highlights = hl

            catppuccin.setup(opts)

            local function reload_catppuccin()
                require('lazy.core.loader').reload('catppuccin')
            end

            vim.api.nvim_create_user_command('ReloadCatppuccin', function()
                reload_catppuccin()
                vim.cmd('source ~/.config/nvim/lua/user/plugins/catppuccin.lua')
                vim.cmd(':colorscheme catppuccin')
            end, {
                nargs = 0,
            })

            -- vim.cmd("command! ReloadCatppuccin lua vim.cmd('ReloadCatppuccin')")
        end,
        priority = 1000,
        lazy = true,
    },
    -- Obsidian.nvim
    {
        'epwalsh/obsidian.nvim',
        -- opts = {
        --         dir = "~/Knowledge",
        --         log_level = vim.log.levels.DEBUG,
        --         daily_notes = {
        --                 folder = "Journal/Daily",
        --                 date_format = "%Y-%m-%d %A",
        --                 alias_format = "%Y-%m-%d",
        --         },
        --         completion = {
        --                 nvim_cmp = true,
        --                 min_chars = 2,
        --                 new_notes_location = "current_dir",
        --                 prepend_note_id = false,
        --         },
        --         mappings = {
        --         },
        --         note_id_func = function(title)
        --                 return title
        --         end,
        --         disable_frontmatter = true,
        --         note_frontmatter_func = function(note)
        --                 local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        --                 if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
        --                         for k, v in pairs(note.metadata) do
        --                                 out[k] = v
        --                         end
        --                 end
        --                 return out
        --         end,
        --         templates = {
        --                 subdir = "Resource/Template",
        --                 date_format = "%Y-%m-%d %A",
        --                 time_format = "%H:%M",
        --         },
        --         backlinks = {
        --                 height = 10,
        --                 wrap = true,
        --         },
        --         follow_url_func = function(url)
        --                 url = vim.fn.shellescape(url)
        --                 vim.fn.jobstart({ "open", url })
        --         end,
        --         use_advanced_uri = true,
        --         open_app_foreground = false,
        --         finder = "telescope.nvim",
        --         open_notes_in = "current"
        -- }
    },
    -- Hammerspoon integration for Neovim
    {
        'oleksiiluchnikov/hs.nvim',
        dir = vim.fn.expand('~/hs.nvim'),
        dev = true,
    },
    -- Jumps in JSON
    {
        'theprimeagen/jvim.nvim',
        config = function()
            vim.keymap.set(
                'n',
                '<left>',
                '<cmd>lua require("jvim").to_parent()<CR>',
                {
                    noremap = true,
                    silent = true,
                    desc = 'Move to parent node in JSON',
                }
            )
            vim.keymap.set(
                'n',
                '<right>',
                '<cmd>lua require("jvim").descend()<CR>',
                {
                    noremap = true,
                    silent = true,
                    desc = 'Descend into JSON node',
                }
            )

            vim.keymap.set(
                'n',
                '<up>',
                '<cmd>lua require("jvim").prev_sibling()<CR>',
                {
                    noremap = true,
                    silent = true,
                    desc = 'Move to previous sibling node in JSON',
                }
            )
            vim.keymap.set(
                'n',
                '<down>',
                '<cmd>lua require("jvim").next_sibling()<CR>',
                {
                    noremap = true,
                    silent = true,
                    desc = 'Move to next sibling node in JSON',
                }
            )
        end,
    },
    -- Centerpad
    {
        'smithbm2316/centerpad.nvim',
    },
    -- Better quickfix
    {
        'kevinhwang91/nvim-bqf',
        config = function()
            local latte = require('catppuccin.palettes').get_palette('latte')

            -- hi BqfPreviewTitle guifg=#3e8e2d ctermfg=71
            -- hi BqfPreviewThumb guibg=#3e8e2d ctermbg=71

            -- vim.cmd('hi BqfPreviewBorder guifg=' .. latte.green)

            vim.cmd('hi BqfPreviewBorder guifg=' .. latte.red)
            vim.cmd('hi BqfPreviewTitle guifg=' .. latte.red)
            vim.cmd('hi BqfPreviewThumb guifg=' .. latte.red)

            vim.cmd('hi link BqfPreviewRange Search')

            require('bqf').setup({
                magic_window = true,
                auto_enable = true,
                auto_resize_height = true, -- highly recommended enable
                preview = {
                    buf_label = true,
                    win_height = 12,
                    show_scroll_bar = false,
                    wrap = false,
                    winblend = 0,
                    auto_preview = true,
                    win_vheight = 12,
                    delay_syntax = 80,
                    border = 'rounded',
                    show_title = false,
                    ---@diagnostic disable-next-line: unused-local
                    should_preview_cb = function(bufnr, qwinid)
                        local ret = true
                        local bufname = vim.api.nvim_buf_get_name(bufnr)
                        local fsize = vim.fn.getfsize(bufname)
                        if fsize > 100 * 1024 then
                            -- skip file size greater than 100k
                            ret = false
                        elseif string.match(bufname, '^fugitive://') then
                            -- skip fugitive buffer
                            ret = false
                        end
                        return ret
                    end,
                },
                -- make `drop` and `tab drop` to become preferred
                func_map = {
                    drop = 'o',
                    openc = 'O',
                    split = '<C-s>',
                    tabdrop = '<C-t>',
                    -- set to empty string to disable
                    tabc = '',
                    ptogglemode = 'z,',
                },
                filter = {
                    fzf = {
                        action_for = {
                            ['ctrl-s'] = 'split',
                            ['ctrl-t'] = 'tab drop',
                        },
                        extra_opts = {
                            '--bind',
                            'ctrl-o:toggle-all',
                            '--prompt',
                            '> ',
                        },
                    },
                },
            })
        end,
        event = 'LspAttach',
    },
    -- Diagnostic information viewer
    {
        'dgagn/diagflow.nvim',
        opts = {
            enable = true,
            max_width = 60,     -- The maximum width of the diagnostic messages
            max_height = 10,    -- the maximum height per diagnostics
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
            text_align = 'right',                                                 -- 'left', 'right'
            placement = 'inline',                                                 -- 'inline', 'floating'
            inline_padding_left = 0,                                              -- the padding left when the placement is inline
            update_event = { 'DiagnosticChanged', 'BufReadPost', 'TextChanged' }, -- the event that updates the diagnostics cache
            toggle_event = { 'InsertEnter' },                                     -- if InsertEnter, can toggle the diagnostics on inserts
            show_sign = true,                                                     -- set to true if you want to render the diagnostic sign before the diagnostic message
            render_event = { 'DiagnosticChanged', 'CursorMoved' },
        },
        event = 'LspAttach',
    },
    -- Code formatter
    {
        'mhartington/formatter.nvim',
        config = function()
            local util = require('formatter.util')
            local formatter = require('formatter')
            local default_opts = {
                logging = false,
                log_level = vim.log.levels.WARN,
                filetype = {
                    lua = {
                        require('formatter.filetypes.lua').stylua,
                        function()
                            -- Supports conditional formatting
                            if
                                util.get_current_buffer_file_name()
                                == 'special.lua'
                            then
                                return nil
                            end

                            return {
                                exe = 'stylua',
                                args = {
                                    '--search-parent-directories',
                                    '--stdin-filepath',
                                    util.escape_path(
                                        util.get_current_buffer_file_path()
                                    ),
                                    '--',
                                    '-',
                                },
                                stdin = true,
                            }
                        end,
                    },
                    python = {
                        require('formatter.filetypes.python').black,
                        function()
                            return {
                                exe = 'black',
                                args = { '-' },
                                stdin = true,
                            }
                        end,
                    },
                    markdown = {
                        function(parser)
                            if not parser then
                                return {
                                    exe = 'prettier',
                                    args = {
                                        '--stdin-filepath',
                                        util.escape_path(
                                            util.get_current_buffer_file_path()
                                        ),
                                    },
                                    stdin = true,
                                    try_node_modules = true,
                                }
                            end

                            return {
                                exe = 'prettier',
                                args = {
                                    '--stdin-filepath',
                                    util.escape_path(
                                        util.get_current_buffer_file_path()
                                    ),
                                    '--parser',
                                    parser,
                                },
                                stdin = true,
                                try_node_modules = true,
                            }
                        end,
                    },
                    rust = {
                        function()
                            return {
                                exe = 'rustfmt',
                                args = {
                                    '--emit=stdout',
                                    '--edition=2021',
                                },
                                stdin = true,
                            }
                        end,
                    },

                    ['*'] = {
                        require('formatter.filetypes.any').remove_trailing_whitespace,
                    },
                },
            }

            -- Automatically run formatter on buffer write
            vim.api.nvim_create_augroup('FormatAutogroup', { clear = true })

            vim.api.nvim_create_autocmd('BufWritePost', {
                group = 'FormatAutogroup',
                pattern = '*',
                callback = function()
                    vim.cmd('Format')
                end,
            })

            formatter.setup(default_opts)

            local augroup_formatter =
                vim.api.nvim_create_augroup('__formatter__', {
                    clear = true,
                })

            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    vim.lsp.buf.format()
                end,
                group = augroup_formatter,
            })

            vim.api.nvim_create_autocmd('InsertLeave', {
                pattern = '*.lua',
                command = 'Format',
                group = augroup_formatter,
            })
        end,
    },
    -- Glow markdown preview
    {
        'npxbr/glow.nvim',
        config = function()
            local plugin = 'glow'
            local is_installed, glow = pcall(require, plugin)
            if not is_installed then
                return
            end

            local glow_path = os.getenv('HOMEBREW_PREFIX') .. '/bin/glow'

            local defaults_opts = {
                glow_path = glow_path,
                install_path = glow_path,
                style = 'dark',
                width = 100,
            }

            glow.setup(defaults_opts)
        end,
    },
    -- Sniprun
    {
        'michaelb/sniprun',
        run = 'zsh ./install.sh',
        opts = {
            interpreter_options = { --# interpreter-specific options, see doc / :SnipInfo <name>

                --# use the interpreter name as key
                GFM_original = {
                    use_on_filetypes = { 'markdown.pandoc' }, --# the 'use_on_filetypes' configuration key is
                    --# available for every interpreter
                },
                Python3_original = {
                    error_truncate = 'auto', --# Truncate runtime errors 'long', 'short' or 'auto'
                },
            },

            --# you can combo different display modes as desired and with the 'Ok' or 'Err' suffix
            --# to filter only sucessful runs (or errored-out runs respectively)
            display = {
                'Classic',       --# display results in the command-line  area
                'VirtualTextOk', --# display ok results as virtual text (multiline is shortened)

                -- "VirtualText",             --# display results as virtual text
                -- "TempFloatingWindow",      --# display results in a floating window
                -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText[Ok/Err]
                -- "Terminal",                --# display results in a vertical split
                -- "TerminalWithCode",        --# display results and code history in a vertical split
                'NvimNotify', --# display with the nvim-notify plugin
                -- "Api"                      --# return output to a programming interface
            },

            live_display = { 'VirtualTextOk' }, --# display mode used in live_mode

            display_options = {
                terminal_scrollback = vim.o.scrollback, --# change terminal display scrollback lines
                terminal_line_number = false,           --# whether show line number in terminal window
                terminal_signcolumn = false,            --# whether show signcolumn in terminal window
                terminal_persistence = true,            --# always keep the terminal open (true) or close it at every occasion (false)
                terminal_width = 45,                    --# change the terminal display option width
                notification_timeout = 2,               --# timeout for nvim_notify output
            },

            --# You can use the same keys to customize whether a sniprun producing
            --# no output should display nothing or '(no output)'
            show_no_output = {
                'NvimNotify',         --# for example, no output in NvimNotify
                'Classic',
                'TempFloatingWindow', --# implies LongTempFloatingWindow, which has no effect on its own
            },

            live_mode_toggle = 'off', --# live mode toggle, see Usage - Running for more info

            --# miscellaneous compatibility/adjustement settings
            inline_messages = false, --# boolean toggle for a one-line way to display messages
            --# to workaround sniprun not being able to display anything

            borders = 'single', --# display borders around floating windows
            --# possible values are 'none', 'single', 'double', or 'shadow'
        },
        config = function()
            vim.api.nvim_set_keymap(
                'v',
                '<leader>x',
                '<Plug>SnipRun',
                { silent = true }
            )
            vim.api.nvim_set_keymap(
                'n',
                '<leader>x',
                '<Plug>SnipRunOperator',
                { silent = true }
            )
        end,
    },
    -- Troube: A pretty, fast, and lean diagnostics manager
    {
        'folke/Trouble.nvim',
        config = function()
            -- LSP Diagnostics Options Setup
            local sign = function(opts)
                vim.fn.sign_define(opts.name, {
                    texthl = opts.name,
                    text = opts.text,
                    numhl = '',
                })
            end
            sign({ name = 'DiagnosticSignError', text = '' })
            sign({ name = 'DiagnosticSignWarn', text = '' })
            sign({ name = 'DiagnosticSignHint', text = '' })
            sign({ name = 'DiagnosticSignInfo', text = '' })

            --- @type vim.diagnostic.Opts
            local default_opts = {
                signs = {
                    -- icons / text used for a diagnostic
                    error = '',
                    warning = '',
                    hint = '',
                    information = '',
                    other = '﫠',
                },
                update_in_insert = true, -- update diagnostics insert mode
                underline = true,        -- show underline diagnostics (default: true)
                virtual_text = {
                    prefix = ' ',
                    spacing = 80,
                },
                severity_sort = {
                    reverse = false, -- reverse the sort order (default: false)
                },
                float = {
                    border = 'single', -- border style (default: "single")
                    -- source = 'always', -- show source (default: "always")
                    source = true,
                    width = 100,      -- width of the output (default: 80)
                    height = 60,      -- height of the output (default: 20)
                    focusable = true, -- focusable (default: false)
                    wrap = true,      -- wrap the lines (default: true)
                },
            }
            vim.diagnostic.config(default_opts)

            -- Trouble(https://github.com/folke/trouble.nvim)
            --- @type trouble.Config
            local trouble_opts = {
                position = 'right', -- position of the list can be: bottom, top, left, right
                height = 10, -- height of the trouble list when position is top or bottom
                width = 50, -- width of the list when position is left or right
                -- icons = true, -- use devicons for filenames
                mode = 'workspace_diagnostics', -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
                severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
                fold_open = '', -- icon used for open folds
                fold_closed = '', -- icon used for closed folds
                group = true, -- group results by file
                padding = true, -- add an extra new line on top of the list
                cycle_results = true, -- cycle item list when reaching beginning or end of list
                action_keys = { -- key mappings for actions in the trouble list
                    -- map to {} to remove a mapping, for example:
                    -- close = {},
                    close = 'q',                                 -- close the list
                    cancel = '<esc>',                            -- cancel the preview and get back to your last window / buffer / cursor
                    refresh = 'r',                               -- manually refresh
                    jump = { '<cr>', '<tab>', '<2-leftmouse>' }, -- jump to the diagnostic or open / close folds
                    open_split = { '<c-x>' },                    -- open buffer in new split
                    open_vsplit = { '<c-v>' },                   -- open buffer in new vsplit
                    open_tab = { '<c-t>' },                      -- open buffer in new tab
                    jump_close = { 'o' },                        -- jump to the diagnostic and close the list
                    toggle_mode = 'm',                           -- toggle between "workspace" and "document" diagnostics mode
                    switch_severity = 's',                       -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
                    toggle_preview = 'P',                        -- toggle auto_preview
                    hover = 'K',                                 -- opens a small popup with the full multiline message
                    preview = 'p',                               -- preview the diagnostic location
                    open_code_href = 'c',                        -- if present, open a URI with more information about the diagnostic error
                    close_folds = { 'zM', 'zm' },                -- close all folds
                    open_folds = { 'zR', 'zr' },                 -- open all folds
                    toggle_fold = { 'zA', 'za' },                -- toggle fold of current file
                    previous = 'k',                              -- previous item
                    next = 'j',                                  -- next item
                    help = '?',                                  -- help menu
                },
                multiline = true,                                -- render multi-line messages
                indent_lines = true,                             -- add an indent guide below the fold icons
                win_config = { border = 'single' },              -- window configuration for floating windows. See |nvim_open_win()|.
                auto_open = false,                               -- automatically open the list when you have diagnostics
                auto_close = false,                              -- automatically close the list when you have no diagnostics
                auto_preview = true,                             -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
                auto_fold = false,                               -- automatically fold a file trouble list at creation
                auto_jump = { 'lsp_definitions' },               -- for the given modes, automatically jump if there is only a single result
                include_declaration = {
                    'lsp_references',
                    'lsp_implementations',
                    'lsp_definitions',
                }, -- for the given modes, include the declaration of the current symbol in the results
                signs = {
                    -- icons / text used for a diagnostic
                    error = '',
                    warning = '',
                    hint = '',
                    information = '',
                    other = '',
                },
                use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
            }
            require('trouble').setup(trouble_opts)

            local keys = {
                {
                    '<leader>xx',
                    '<cmd>Trouble diagnostics toggle<cr>',
                    desc = 'Diagnostics (Trouble)',
                },
                {
                    '<leader>xX',
                    '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
                    desc = 'Buffer Diagnostics (Trouble)',
                },
                {
                    '<leader>cs',
                    '<cmd>Trouble symbols toggle focus=false<cr>',
                    desc = 'Symbols (Trouble)',
                },
                {
                    '<leader>cl',
                    '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
                    desc = 'LSP Definitions / references / ... (Trouble)',
                },
                {
                    '<leader>xL',
                    '<cmd>Trouble loclist toggle<cr>',
                    desc = 'Location List (Trouble)',
                },
                {
                    '<leader>xQ',
                    '<cmd>Trouble qflist toggle<cr>',
                    desc = 'Quickfix List (Trouble)',
                },
            }

            for _, key in ipairs(keys) do
                vim.keymap.set('n', key[1], key[2])
            end
        end,
    },
    -- Todo comments: highlight, list and search todo comments in your projects
    {
        'folke/todo-comments.nvim',
    },
    {
        'rcarriga/nvim-notify',
        ---@type notify.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            background_colour = 'NotifyBackground',
            fps = 1,
            icons = {
                DEBUG = '',
                ERROR = '',
                INFO = '',
                TRACE = '✎',
                WARN = '',
            },
            level = vim.log.levels.INFO,
            minimum_width = 100,
            top_down = false,
            render = 'default',
            timeout = 20,
        },
        init = function()
            ---@class user.plugins.nvim-notify.notify.Options
            --- Custom options for an individual notification
            ---@field title? string
            ---@field icon? string
            ---@field timeout? number|boolean Time to show notification in milliseconds, set to false to disable timeout.
            ---@field on_open? function Callback for when window opens, receives window as argument.
            ---@field on_close? function Callback for when window closes, receives window as argument.
            ---@field keep? function Function to keep the notification window open after timeout, should return boolean.
            ---@field render? function|string Function to render a notification buffer.
            ---@field replace? integer|notify.Record Notification record or the record `id` field. Replace an existing notification if still open. All arguments not given are inherited from the replaced notification including message and level.
            ---@field hide_from_history? boolean Hide this notification from the history
            ---@field animate? boolean If false, the window will jump to the timed stage. Intended for use in blocking events (e.g. vim.fn.input)

            --- Display a notification.
            ---@param message string|string[] Notification message
            ---@param level? string|number? Log level. See vim.log.levels
            ---@param opts? user.plugins.nvim-notify.notify.Options? Notification options
            ---@return notify.Record
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(message, level, opts)
                return require('notify')(message, level, opts)
            end
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '│' },
                change = { text = '│' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
                untracked = { text = '┆' },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,  -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1,
            },
        },
    },
    {
        'jakewvincent/mkdnflow.nvim',
    },
    {
        'axkirillov/easypick.nvim',
        config = function()
            local easypick = require('easypick')
            local previewers = require('telescope.previewers')
            local from_entry = require('telescope.from_entry')
            local Path = require('plenary.path')
            local utils = require('telescope._extensions.repo.utils')

            local function search_markdown_readme(dir)
                for _, name in pairs({
                    'README',
                    'README.md',
                    'README.markdown',
                    'README.mkd',
                }) do
                    local file = dir / name
                    if file:is_file() then
                        return file
                    end
                end
                return nil
            end

            local function search_generic_readme(dir)
                local doc_path = Path:new(dir, 'README.*')
                local maybe_doc =
                    vim.split(vim.fn.glob(doc_path.filename), '\n')
                for _, filepath in pairs(maybe_doc) do
                    local file = Path:new(filepath)
                    if file:is_file() then
                        return file
                    end
                end
                return nil
            end

            local function search_doc(dir)
                local doc_path = Path:new(dir, 'doc', '**', '*.txt')
                local maybe_doc =
                    vim.split(vim.fn.glob(doc_path.filename), '\n')
                for _, filepath in pairs(maybe_doc) do
                    local file = Path:new(filepath)
                    if file:is_file() then
                        return file
                    end
                end
                return nil
            end

            -- -- TODO: I want to pass list of tags to this function
            -- --- @diagnostic disable-next-line: unused-function
            -- local function list_dir_with_tags(tags)
            --     local cmd = 'mdfind "kMDItemUserTags == \'*'
            --         .. tags
            --         .. '*\' && kMDItemContentType == \'public.folder\'"'
            --     local result = vim.fn.systemlist(cmd)
            --     return result
            -- end

            local gen_remote_repos_command = [=[
home_username=$(basename "$HOME")
email="oleksiiluchnikov@gmail.com"  # Adjust this to your email

# Use -d for search depth, adjust as needed
# Combine rg patterns
fd -H -t d -d 10 ".git" | while read -r gitdir; do
    repo_path=$(dirname "$gitdir")

    # Ensure that the directory contains a config file
    if [[ -f "$gitdir/config" ]]; then
        if rg -q "(url.*$home_username|$email)" "$gitdir/config"; then
            echo "$repo_path"
        fi
    fi
done
]=]

            easypick.setup({
                pickers = {
                    {
                        name = 'remote_repos',
                        command = gen_remote_repos_command,
                        previewer = previewers.new_termopen_previewer({
                            get_command = function(entry)
                                local dir = Path:new(from_entry.path(entry))
                                local doc = search_markdown_readme(dir)
                                if doc then
                                    return utils.find_markdown_previewer_for_document(
                                        doc.filename
                                    )
                                end
                                doc = search_generic_readme(dir)
                                if not doc then
                                    doc = search_doc(dir)
                                end
                                if not doc then
                                    return { 'echo', '' }
                                end
                                return utils.find_generic_previewer_for_document(
                                    doc.filename
                                )
                            end,
                        }),
                    },
                    {
                        name = 'my_repos',
                        command =
                        'mdfind "kMDItemUserTags == \'*Repository*\' && kMDItemContentType == \'public.folder\'"',
                        previewer = previewers.new_termopen_previewer({
                            get_command = function(entry)
                                local dir = Path:new(from_entry.path(entry))
                                local doc = search_markdown_readme(dir)
                                if doc then
                                    return utils.find_markdown_previewer_for_document(
                                        doc.filename
                                    )
                                end
                                doc = search_generic_readme(dir)
                                if not doc then
                                    doc = search_doc(dir)
                                end
                                if not doc then
                                    return { 'echo', '' }
                                end
                                return utils.find_generic_previewer_for_document(
                                    doc.filename
                                )
                            end,
                        }),
                    },
                },
            })
        end,
    },
    {
        'jackMort/ChatGPT.nvim',
        config = function()
            vim.defer_fn(function()
                require('user.plugins.chatgpt')
            end, 100)
        end,
    },
    {
        'MunifTanjim/nui.nvim',
    },
    {
        'ThePrimeagen/vim-be-good',
    },
    {
        'oleksiiluchnikov/vault.nvim',
        dir = vim.fn.expand('~/vault.nvim'),
        config = function()
            vim.defer_fn(function()
                require('user.plugins.vault')
            end, 100)
        end,
    },
    {
        'rebelot/kanagawa.nvim',
        opts = {
            compile = false,  -- enable compiling the colorscheme
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            typeStyle = {},
            transparent = false,   -- do not set background color
            dimInactive = true,    -- dim inactive window `:h hl-NormalNC`
            terminalColors = true, -- define vim.g.terminal_color_{0,17}
            colors = {             -- add/modify theme and palette colors
                palette = {},
                theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
            },
            --- @diagnostic disable-next-line: unused-local
            overrides = function(colors) -- add/modify highlights
                return {}
            end,
            theme = 'wave',    -- Load "wave" theme when 'background' option is not set
            background = {     -- map the value of 'background' option to a theme
                dark = 'wave', -- try "dragon" !
                light = 'lotus',
            },
        },
    },
    {
        'oleksiiluchnikov/telescope-dotfiles.nvim',
        dir = vim.fn.expand('~/telescope-dotfiles.nvim'),
    },
    {
        'oleksiiluchnikov/eagle.nvim',
        dir = vim.fn.expand('~/eagle.nvim'),
    },
    {
        'edluffy/hologram.nvim',
    },
    {
        'oleksiiluchnikov/gradient.nvim',
        dir = vim.fn.expand('~/gradient.nvim'),
    },
    {
        'oleksiiluchnikov/dates.nvim',
        dir = vim.fn.expand('~/dates.nvim'),
    },
    {
        'simrat39/symbols-outline.nvim',
        opts = {
            highlight_hovered_item = true,
            show_guides = true,
            auto_preview = false,
            position = 'right',
            relative_width = true,
            auto_close = false,
            show_numbers = false,
            show_relative_numbers = false,
            show_symbol_details = true,
            preview_bg_highlight = 'Pmenu',
            autofold_depth = nil,
            auto_unfold_hover = true,
            fold_markers = { '', '' },
            wrap = false,
            keymaps = { -- These keymaps can be a string or a table for multiple keys
                close = { '<Esc>', 'q' },
                goto_location = '<Cr>',
                focus_location = 'o',
                hover_symbol = '<C-space>',
                toggle_preview = 'K',
                rename_symbol = 'r',
                code_actions = 'a',
                fold = 'h',
                unfold = 'l',
                fold_all = 'W',
                unfold_all = 'E',
                fold_reset = 'R',
            },
            lsp_blacklist = {},
            symbol_blacklist = {},
            symbols = {
                File = { icon = 'f', hl = '@text.uri' },
                Module = { icon = 'M', hl = '@namespace' },
                Namespace = { icon = '', hl = '@namespace' },
                Package = { icon = '', hl = '@namespace' },
                Class = { icon = 'Class', hl = '@type' },
                Method = { icon = 'method', hl = '@method' }, -- Updated method icon
                Property = { icon = 'Property', hl = '@method' },
                Field = { icon = 'Field', hl = '@field' },
                Constructor = { icon = '', hl = '@constructor' },
                Enum = { icon = 'Enum', hl = '@type' },
                Interface = { icon = 'I', hl = '@type' },
                Function = { icon = 'ƒ', hl = '@function' },
                Variable = { icon = 'V', hl = '@constant' },
                Constant = { icon = 'C', hl = '@constant' },
                String = { icon = 'S', hl = '@string' },
                Number = { icon = '#', hl = '@number' },
                Boolean = { icon = 'B', hl = '@boolean' },
                Array = { icon = 'A', hl = '@constant' },
                Object = { icon = 'O', hl = '@type' },
                Key = { icon = 'K', hl = '@type' },
                Null = { icon = 'NULL', hl = '@type' },
                EnumMember = { icon = 'E', hl = '@field' },
                Struct = { icon = 'S', hl = '@type' },
                Event = { icon = 'E', hl = '@type' },
                Operator = { icon = '+', hl = '@operator' },
                TypeParameter = { icon = 'T', hl = '@parameter' },
                Component = { icon = 'C', hl = '@function' },
                Fragment = { icon = 'F', hl = '@constant' },
            },
        },
    },
    {
        'bennypowers/nvim-regexplainer',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'MunifTanjim/nui.nvim',
        },
        opts = {
            -- 'narrative'
            mode = 'narrative', -- TODO: 'ascii', 'graphical'

            -- automatically show the explainer when the cursor enters a regexp
            auto = true,

            -- filetypes (i.e. extensions) in which to run the autocommand
            filetypes = {
                'html',
                'js',
                'cjs',
                'mjs',
                'ts',
                'jsx',
                'tsx',
                'cjsx',
                'mjsx',
                'lua',
                'svelte',
                'rs',
                'css',
                'scss',
                'md',
                'markdown',
                'vim',
            },

            -- Whether to log debug messages
            debug = false,

            -- 'split', 'popup'
            display = 'popup',

            mappings = {
                toggle = 'gR',
                -- examples, not defaults:
                -- show = 'gS',
                -- hide = 'gH',
                -- show_split = 'gP',
                -- show_popup = 'gU',
            },

            narrative = {
                separator = '\n',
            },
        },
    },
    {
        'projekt0n/github-nvim-theme',
    },
    {
        'simrat39/inlay-hints.nvim',
        config = function()
            require('inlay-hints').setup({
                only_current_line = true,
                eol = {
                    right_align = true,
                },
            })
        end,
    },
    {
        'dpayne/CodeGPT.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
        },
        config = function()
            vim.defer_fn(function()
                require('codegpt.config')
            end, 200)
        end,
    },
    {
        'AckslD/messages.nvim',
        opts = {
            command_name = 'Messages',
            -- should prepare a new buffer and return the winid
            -- by default opens a floating window
            -- provide a different callback to change this behaviour
            -- @param opts: the return value from float_opts
            buffer_name = 'messages',
            prepare_buffer = function(opts)
                -- for _, win in ipairs(vim.api.nvim_list_wins()) do
                --     if vim.api.nvim_win_get_buf(win) == vim.fn.bufnr("messages") then
                --         -- vim.api.nvim_win_close(win, true)
                --         -- get lines
                --         local lines = vim.api.nvim_buf_get_lines(
                --             vim.fn.bufnr("messages"),
                --             0,
                --             -1,
                --             false
                --         )
                --     end
                -- end

                local buf = vim.api.nvim_create_buf(false, true)
                vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf })
                return vim.api.nvim_open_win(buf, true, opts)
            end,
            -- should return options passed to prepare_buffer
            -- @param lines: a list of the lines of text
            buffer_opts = function(_)
                local gheight = vim.api.nvim_list_uis()[1].height
                local gwidth = vim.api.nvim_list_uis()[1].width
                return {
                    relative = 'win',
                    width = gwidth - 2,
                    height = gheight,
                    anchor = 'SW',
                    row = gheight - 1,
                    col = 0,
                    style = 'minimal',
                    border = 'rounded',
                    zindex = 1,
                }
            end,
            -- what to do after opening the float
            post_open_float = function()
                -- set background to #000000
                -- vim.api.nvim_win_set_option(
                --     winnr,
                --     "winhighlight",
                --     "NormalFloat:NormalFloat"
                -- )
            end,
        },
    },
    {
        'sourcegraph/sg.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('sg').setup({
                on_attach = on_attach_lsp,
                chat = {
                    default_model = 'anthropic/claude-3-haiku-20240317',
                },
            })
            -- Init Cody
            -- Then we need to create the autogroup
            vim.api.nvim_create_augroup('Sourcegraph', {
                clear = true,
            })

            -- Then we need to create the autocommand
            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                pattern = '*',
                callback = function()
                    -- First we need to get the width of the screen
                    local screen_width = vim.api.nvim_list_uis()[1].width
                    local width = math.floor(screen_width * 0.5)

                    -- Then we need to calculate the width of the floating window
                    local win = vim.api.nvim_get_current_win()
                    local buf = vim.api.nvim_win_get_buf(win)
                    -- if current buffer has "Cody History" in it's name
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    if not string.find(bufname, 'Cody History') then
                        return
                    end
                    vim.api.nvim_win_set_width(0, width)
                end,
            })

            -- If the current buffer is a floating window
            -- then place align in to the bootom of the screen
            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                pattern = '*',
                callback = function()
                    -- Detect if the current buffer is a floating window
                    local win = vim.api.nvim_get_current_win()
                    local buf = vim.api.nvim_win_get_buf(win)
                    -- if current buffer has "Cody History" in it's name
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    if not string.find(bufname, 'Cody History') then
                        return
                    end

                    -- First we need to get the width of the screen
                    local screen_width = vim.api.nvim_list_uis()[1].width
                    local screen_height = vim.api.nvim_list_uis()[1].height
                    local width = math.floor(screen_width * 0.8)
                    local height = math.floor(screen_height * 0.3)

                    -- Then we need to calculate the width of the floating window
                    vim.api.nvim_win_set_width(0, width)
                    vim.api.nvim_win_set_height(0, height)
                    vim.api.nvim_win_set_config(0, {
                        relative = 'editor',
                        row = 0,
                        col = 0,
                    })
                end,
            })

            local cody = require('sg.cody.commands')
            local utils = vim.u.utils

            local function get_cody_answer()
                local bufnr = vim.api.nvim_get_current_buf()
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                for i, line in ipairs(lines) do
                    lines[i] = nil
                    if line:match('^%s*```.*$') then
                        lines[i] = nil
                        break
                    end
                end
                --- set height of the window to the number of lines in the buffer
                --- replace the content of the buffer with the lines
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines or {})
            end

            --- Shorten type error
            ---@return nil
            local function shorten_type_error()
                -- Use a local variable to store the instruction string
                local instruction =
                'Clearly explain this diagnostic from LSP request for `%s` code in details and how to fix it:\n%s\nRemove all unnecessary noise. No yapping!\n\n'

                ---@type vim.Diagnostic[]
                local diagnostic = vim.diagnostic.get(0)
                if next(diagnostic) == nil then
                    return
                end

                -- Jump to the first diagnostic
                vim.api.nvim_win_set_cursor(0, { diagnostic[1].lnum, 0 })

                -- Get the filetype and append the Lua version if it's Lua
                local filetype = vim.bo.filetype
                if filetype == 'lua' then
                    filetype = filetype .. ' ' .. utils.get_lua_version()
                end
                local prompt_instruction = string.format(
                    instruction,
                    filetype,
                    vim.inspect(diagnostic[1])
                ) .. '\n\n' .. diagnostic[1].message

                local bufnr = vim.api.nvim_get_current_buf()
                cody.do_task(bufnr, 0, 0, prompt_instruction)
                vim.defer_fn(function()
                    get_cody_answer()
                end, 3000)
            end

            -- Commands
            vim.api.nvim_create_user_command('CodyShortenTypeError', function()
                shorten_type_error()
            end, {
                nargs = 0,
            })

            --- Improve prompt instruction for `Cody`.
            --- @param start_line number
            --- @param end_line number
            --- @returns nil
            local function improve_prompt_instruction(start_line, end_line)
                local instruction = [=[
            Please rewrite following prompt instruction to:
            - Clearly state the specific task or goal
            - Provide necessary context, guidelines, and requirements for LLM model
            - Include concrete examples if helpful in <example> XML tag
            - Be clear, concise, and detailed for easy following. No yapping!
            - Improve on the current prompt with more details and specificity
            - Let me know if any part of the prompt needs clarification.
            - If you don't know how to answer, just say "I don't know".

            Return optimal prompt instruction. Keep it short and sweet. No yapping!
            Here is the prompt string you need to improve:
            <string-to-improve>
            ]=]

                local prompt_instruction =
                    string.format(instruction, vim.bo.filetype)
                local bufnr = vim.api.nvim_get_current_buf()
                cody.do_task(bufnr, start_line, end_line, prompt_instruction)
            end

            vim.api.nvim_create_user_command(
                'CodyImprovePromptInstruction',
                function()
                    local start_line, end_line = utils.get_selection_lines()
                    improve_prompt_instruction(start_line, end_line)
                end,
                {
                    nargs = 0,
                    range = true,
                }
            )

            --- Generate commit message for current changes
            local function generate_commit_message()
                local instruction = [=[
            Cody, generate a commit message for the current changes.

            You are provided the following staged changes:

            %s

            Please generate a commit message that:

            - Concisely summarizes the changes in the diff
            - Uses conventional commit types like feat, fix, docs etc.
            - Omits minor or unnecessary details
            - Follows Conventional Commits spec: https://www.conventionalcommits.org/

            The commit message should:
            - Be short, clear and easy to understand
            - Explain what was changed and why
            - Follow best practices for formatting and style

            Bellow suggest more optimal prompt instruction for this task.
            ]=]

                local git_diff = vim.fn.system('git diff --staged')
                cody.do_task(
                    vim.api.nvim_get_current_buf(),
                    0,
                    1,
                    string.format(instruction, git_diff)
                )
            end

            vim.api.nvim_create_user_command(
                'CodyGenerateCommitMessage',
                function()
                    generate_commit_message()
                end,
                {
                    nargs = 0,
                }
            )

            ---@param start_line number
            ---@param end_line number
            local function add_lua_type_annotations(start_line, end_line)
                local instruction = [=[
            Hey, Cody! Let make you to act as a Senior Type Annotator for the Lua code.
            Here the guide page where you could see how I want the code to be annotated:
            ```markdown
            %s
            ```
            ---
            Generate type annotations with following recommendations:
            - Follow neovim community conventions for type annotations.
            - Add a general comment above the code snippet to explain the purpose of the code.
            - if function void, then add return type `nil`
            - Do not add type annotations for function calls, only for function definitions.
            - Add type annotations for all function arguments and return values.
            - Keep type annotations above the function definition.
            - Do not add newlines!
            - Update only the provided code snippet.
            ]=]

                local guide = vim.fn.readfile(
                    vim.fn.stdpath('config')
                    .. '/prompts/lua_type_annotations.txt'
                )
                local prompt_instruction =
                    string.format(instruction, table.concat(guide, '\n'))
                local bufnr = vim.api.nvim_get_current_buf()
                local selected_lines = vim.api.nvim_buf_get_lines(
                    bufnr,
                    start_line - 1,
                    end_line,
                    false
                )
                vim.notify(table.concat(selected_lines, '\n'))
                cody.do_task(
                    bufnr,
                    start_line - 1,
                    end_line,
                    prompt_instruction
                )
            end

            vim.api.nvim_create_user_command(
                'CodyAddTypeAnnotations',
                function()
                    local start_line, end_line = utils.get_selection_lines()
                    add_lua_type_annotations(start_line, end_line)
                end,
                {
                    nargs = 0,
                    range = true,
                }
            )

            -- Ask Cody to optiviaze the chunk of code to make it blazing fast, and more idiomatic.
            local function optimize_lua_code(start_line, end_line)
                local instruction = [=[
            Cody, optimize only the provided code snippet.
            Keep in mind that this is a small part of a larger codebase.
            So you should not change any existing code, only optimize the provided snippet.
            Or suggest a better way to do it, unless you see is already perfect.

            Please optimize this chunk of code:

            - Performance - use optimal algorithms and data structures. Avoid unnecessary loops, recursion, and other complex code
            - Readability - follow %s style guides and conventions
            - Specifically for Lua:
            - If you see `vim` that means that lua code is using neovim.API. Then its "LuaJIT" flavor is used.
            - Add type annotations and documentation to support the Lua language server from sumneko.
            - Add usage example in comments with asserts above the function.
            ---local notes = Notes():with_title_mismatched()
            ---local note = notes:get_random_note()
            ---assert(note.data.title ~= note.data.stem)

            - Maintainability - modularize into focused functions with docs. Avoid global variables and other anti-patterns.
            - Clarity - add types and comments explaining complex sections. If it's not clear, it's not optimized!
            - Formatting - proper indentation, whitespace, 100 char line length, etc.

            The optimized code should:
            - Be blazing fast. Performance is the top priority!
            - Be idiomatic and conform to %s best practices.
            - Have logical, modular functions and components, but don't do dumb wrappings and other anti-patterns.
            - Contain annotations and docs for understanding complex sections.
            - Explain optimizations in comments above the code if it's not obvious.
            - Be properly formatted and indented

            Give the explanation for the optimizations you made in mulitline comment above the code.
            Let me know if any part of the prompt needs clarification!
            Like in this example:
            "Optimizations:

            - Use string.format instead of concatenation for performance
            - Cache the osascript command format string since it doesn't change
            - Use vim.cmd over vim.fn.system since we don't need the output
            - Add comments explaining the purpose and optimizations
            ]=]
                local filetype = vim.bo.filetype
                if filetype == 'lua' then
                    filetype = filetype .. ' ' .. utils.get_lua_version()
                end
                local prompt_instruction = string.format(
                    instruction,
                    filetype,
                    filetype,
                    filetype,
                    filetype
                )

                local bufnr = vim.api.nvim_get_current_buf()
                cody.do_task(bufnr, start_line, end_line, prompt_instruction)
            end

            vim.api.nvim_create_user_command('CodyOptimizeCode', function()
                optimize_lua_code(utils.get_selection_lines())
            end, {
                nargs = 0,
                range = true,
            })

            local function improve_documentation(start_line, end_line)
                local instruction = [=[
        Cody, improve documentation for the provided code snippet.

        Please improve documentation for this chunk of code:

        ]=]
                local prompt_instruction =
                    string.format(instruction, vim.bo.filetype)
                cody.do_task(
                    vim.api.nvim_get_current_buf(),
                    start_line,
                    end_line,
                    prompt_instruction
                )
            end

            vim.api.nvim_create_user_command(
                'CodyImproveDocumentation',
                function()
                    improve_documentation(utils.get_selection_lines())
                end,
                {
                    nargs = 0,
                    range = true,
                }
            )

            local function cody_hard_reset()
                vim.cmd('q!')
                vim.cmd('CodyRestart')
            end

            vim.api.nvim_create_user_command('CodyReset', function()
                cody_hard_reset()
            end, {
                nargs = 0,
            })

            --- Sometimes I have a code snippet where "--to be implemented" is written.
            --- or "TODO: implement this function"
            --- or any other comment that indicates that this code is not ready.
            --- Maybe there only human only comments like "We do this yada yada yada"
            --- So I want to ask Cody to try to implement this code with explanation,
            --- and focus on blazing fast performance.

            vim.api.nvim_create_user_command(
                'CodySolveCommentedInstruction',
                function()
                    local start_line, end_line = utils.get_selection_lines()
                    -- The good prompt instruction for this task is:
                    local instruction = [=[
        Cody, implement the commented code snippet.
        Keep in mind that this is a small part of a larger codebase.
        So you should not change any existing code, only implement the provided snippet.
        Or suggest a better way to do it, unless you see is already perfect.
        Focus on blazing fast performance and best practices for that language, and community conventions.

        Please implement this chunk of code:

        ]=]
                    local prompt_instruction =
                        string.format(instruction, vim.bo.filetype)
                    local bufnr = vim.api.nvim_get_current_buf()
                    cody.do_task(
                        bufnr,
                        start_line,
                        end_line,
                        prompt_instruction
                    )
                end,
                {
                    nargs = 0,
                    range = true,
                }
            )

            local function improve_performance(start_line, end_line)
                local instruction = [=[
    # Optimize %s code snippet for performance

    Task: Improve the performance of the provided %s code snippet by making it as fast as possible while adhering to idiomatic coding practices.

    Context:
    - The code snippet is a part of a larger codebase.
    - You should not modify any existing code outside the provided snippet.
    - If the existing code is already optimal, suggest a better way to achieve the same functionality.
    - Add comments above the changes to explain the optimizations made.

    Requirements:
    - Maintain the existing functionality of the code.
    - Ensure that the optimized code follows best and common practices and conventions for the %s language and is idiomatic.
    - Provide clear and concise comments explaining the optimizations made.
    - Define a naming convention of variables, functions, and classes of the original code and stay consistent with it.
    - If the existing code has type annotations, expand them to include the necessary type information for the optimized code.
    - Use early returns and short-circuit evaluation to improve performance.
    - At the end of the answer, append test function for it.

    Suggestions:
    - Use the existing code as a reference to optimize the provided code snippet.
    - Use the existing code as a guide to improve the performance of the provided code snippet.
    - Use the existing code as a starting point to optimize the provided code snippet.
    - Use the existing code as a benchmark to compare the performance of the optimized code snippet.
    - Use the existing code as a reference to identify areas that can be optimized in the provided code snippet.

    Provide the optimized Lua code snippet with clear and concise comments explaining the optimizations made. If the existing code is already optimal, suggest a better way to achieve the same functionality or provide a brief explanation stating that the code is already optimized. for
    ```
    ]=]
                local prompt_instruction = string.format(
                    instruction,
                    vim.bo.filetype,
                    vim.bo.filetype,
                    vim.bo.filetype
                )
                local bufnr = vim.api.nvim_get_current_buf()
                cody.do_task(bufnr, start_line, end_line, prompt_instruction)
            end

            vim.api.nvim_create_user_command('CodyBlazingFast', function()
                improve_performance(utils.get_selection_lines())
            end, {
                nargs = 0,
                range = true,
            })

            -- Load the website content and convert the HTML content to Markdown format
            ---@param url string The URL of the website to load
            ---@return string?
            local function load_website_content(url)
                ---@type string?
                local content

                local handle = io.popen('curl -s ' .. url, 'r')
                if not handle then
                    return nil
                end

                content = handle:read('*a')
                handle:close()

                return content
            end

            --- Annotate lua code snippet with type annotations
            ---@param start_line integer
            ---@param end_line integer
            local function lua_annotate(start_line, end_line)
                ---@type string?
                local lua_type_annotations_doc = load_website_content(
                    'https://raw.githubusercontent.com/LuaLS/LuaLS.github.io/main/src/content/wiki/annotations.mdx'
                )
                if not lua_type_annotations_doc then
                    print('nil')
                    return
                end
                local bufnr = vim.api.nvim_get_current_buf()
                -- local prompt_instruction = 'TLDR ' .. lua_type_annotations_doc
                local prompt_instruction = [[
                <task>Improve the type annotations of the provided Lua code snippet by making them descriptive and easy to understand.</task>

                <context>
                <item>The code snippet is a part of a larger codebase.</item>
                <item>If the existing code is already optimally annotated, suggest a better way to achieve the same functionality.</item>
                <item>Add comments to the type annotations to explain them if they are ambiguous.</item>
                </context>

                <requirements>
                <item>Maintain the existing functionality of the code.</item>
                <item>Ensure that the optimized code follows best and common practices and conventions for the Lua language and is idiomatic.</item>
                <item>If the existing code has type annotations, expand them.</item>
                <item>Add examples with asserts.</item>
                </requirements>

                <example>
                ```lua
                --- The example to get a random example from.
                --- @param example Example -- The example to get a random example from.
                --- @return example Example -- The random example.
                --- ```lua
                --- local example = Example():with_title_mismatched()
                --- local example = example:get_random_example()
                ---
                --- assert(example.data.title ~= example.data.stem)
                --- ```
                local function get_random_example(example)
                    return example:get_random_example()
                end
                ```
                </example>

                <code_snippet>
                ```lua
                ]]
                prompt_instruction =
                    string.format(prompt_instruction, lua_type_annotations_doc)
                cody.do_task(
                    bufnr,
                    start_line - 1,
                    end_line,
                    prompt_instruction
                )
            end

            vim.api.nvim_create_user_command('CodyAnnotate', function()
                lua_annotate(utils.get_selection_lines())
            end, {
                nargs = 0,
                range = true,
            })

            vim.api.nvim_create_user_command(
                'CodyRewriteCodeWithExample',
                function()
                    local start_line, end_line = utils.get_selection_lines()
                    local instruction = [=[
                [[ Task: Rewrite the provided code snippet in Lua to make it more readable, maintainable, and efficient.

                Context:
                - The code is a Lua script that performs some operations.
                - Aim to improve variable naming, code structure, and comments.
                - Optimize performance where possible without changing functionality.

                Requirements:
                - Preserve the original functionality of the code.
                - Use meaningful variable and function names following Lua conventions.
                - Add comments to explain complex or non-obvious sections of the code.
                - Split large functions into smaller, reusable functions if applicable.
                - Remove any unnecessary or redundant code.
                - Optimize performance-critical sections if possible.

                Example:
                <example>
                -- Original code
                a = 5
                b = 10
                c = a + b
                print(c) -- Output: 15
                </example>

                -- Improved code
                <example>
                -- Declare and initialize variables with meaningful names
                first_number = 5
                second_number = 10

                -- Calculate the sum
                sum = first_number + second_number

                -- Print the result
                print(sum) -- Output: 15
                </example>

                If any part of the prompt needs clarification, please let me know.
                If you don't know how to improve the code, simply respond with "I don't know".]=]

                    local prompt_instruction =
                        string.format(instruction, vim.bo.filetype)
                    local bufnr = vim.api.nvim_get_current_buf()
                    cody.do_task(
                        bufnr,
                        start_line,
                        end_line,
                        prompt_instruction
                    )
                end,
                {
                    nargs = 0,
                    range = true,
                }
            )

            vim.api.nvim_create_user_command('CodyDescribeRepo', function(args)
                -- -- Read all files in the current directory
                -- -- local files = vim.fn.readdir(utils.get_root_dir())
                -- local files = vim.fn.glob(utils.get_root_dir() .. '/**/*.lua', true, true)
                -- -- Filter out files that are not Lua files
                -- local lua_files = vim.tbl_filter(function(file)
                --     return string.match(file, '%.lua$')
                -- end, files)
                --
                -- -- Sort the files alphabetically
                -- table.sort(lua_files)
                --
                -- local modules = {}
                -- -- Print the files
                -- for _, file in ipairs(lua_files) do
                --     -- local module_name = string.match(file, '^.*/(.*)%.lua$')
                --     local module_name = string.match(file, '^.*/(.*)%.lua$')
                --     if module_name == 'init' or module_name == 'init_spec' then
                --         module_name = string.match(file, '^.*/(.*)/init.*%.lua$')
                --     end
                --     if not modules[module_name] then
                --         modules[module_name] = {}
                --     end
                --     local content = { '<lua-module-' .. module_name .. '>' }
                --     -- vim.tbl_extend('force', content, vim.fn.readfile(file))
                --     vim.list_extend(content, vim.fn.readfile(file))
                --     table.insert(content, '</lua-module-' .. module_name .. '>')
                --     table.insert(modules, table.concat(content, '\n'))
                -- end
                -- -- print(table.concat(modules, '\n'))
                -- local prompt_instruction = { 'Generate README.md for the current project.' }
                -- prompt_instruction = vim.tbl_extend('force', prompt_instruction, modules)
                -- cody.ask(prompt_instruction)
                -- -- cody.do_task(0, 0, 0, table.concat(prompt_instruction, '\n'))
                cody.ask_really(args.fargs)
            end, {
                nargs = '*',
            })
        end,
    },
    {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
    },
    -- oil.nvim
    {
        'stevearc/oil.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        --- @type oil.SetupOpts
        opts = {
            columns = { 'icon' },
            keymaps = {
                ['<C-h>'] = false,
                ['<M-h>'] = 'actions.select_split',
            },
            view_options = {
                show_hidden = true,
            },
            git = {
                enable = true,
                ignore = true,
            },
        },
        init = function()
            -- swap ":Ex" with ":Oil" command
            vim.api.nvim_create_user_command('Ex', ':Oil', {})

            -- Open parent directory in current window
            vim.keymap.set(
                'n',
                '-',
                '<CMD>Oil<CR>',
                { desc = 'Open parent directory' }
            )

            -- Open parent directory in floating window
            vim.keymap.set('n', '<space>-', require('oil').toggle_float)
        end,
    },
    {
        'folke/ts-comments.nvim',
        opts = {},
        event = 'VeryLazy',
        enabled = vim.fn.has('nvim-0.10.0') == 1,
    },
    {
        'ellisonleao/gruvbox.nvim',
        config = function()
            require('gruvbox').setup({
                contrast = 'hard',
                palette_overrides = { dark0_hard = '#0E1018' },
                overrides = {
                    -- Comment = {fg = "#626A73", italic = true, bold = true},
                    -- #736B62,  #626273, #627273
                    Comment = { fg = '#81878f', italic = true, bold = true },
                    Define = { link = 'GruvboxPurple' },
                    Macro = { link = 'GruvboxPurple' },
                    ['@constant.builtin'] = { link = 'GruvboxPurple' },
                    ['@storageclass.lifetime'] = { link = 'GruvboxAqua' },
                    ['@text.note'] = { link = 'TODO' },
                    ['@namespace.latex'] = { link = 'Include' },
                    ['@namespace.rust'] = { link = 'Include' },
                    ContextVt = { fg = '#878788' },
                    CopilotSuggestion = { fg = '#878787' },
                    CocCodeLens = { fg = '#878787' },
                    CocWarningFloat = { fg = '#dfaf87' },
                    CocInlayHint = { fg = '#ABB0B6' },
                    CocPumShortcut = { fg = '#fe8019' },
                    CocPumDetail = { fg = '#fe8019' },
                    DiagnosticVirtualTextWarn = { fg = '#dfaf87' },
                    -- fold
                    Folded = { fg = '#fe8019', bg = '#3c3836', italic = true },
                    FoldColumn = { fg = '#fe8019', bg = '#0E1018' },
                    SignColumn = { bg = '#fe8019' },
                    -- new git colors
                    DiffAdd = {
                        bold = true,
                        reverse = false,
                        fg = '',
                        bg = '#2a4333',
                    },
                    DiffChange = {
                        bold = true,
                        reverse = false,
                        fg = '',
                        bg = '#333841',
                    },
                    DiffDelete = {
                        bold = true,
                        reverse = false,
                        fg = '#442d30',
                        bg = '#442d30',
                    },
                    DiffText = {
                        bold = true,
                        reverse = false,
                        fg = '',
                        bg = '#213352',
                    },
                    -- statusline
                    StatusLine = { bg = '#ffffff', fg = '#0E1018' },
                    StatusLineNC = { bg = '#3c3836', fg = '#0E1018' },
                    CursorLineNr = { fg = '#fabd2f', bg = '' },
                    GruvboxOrangeSign = { fg = '#dfaf87', bg = '' },
                    GruvboxAquaSign = { fg = '#8EC07C', bg = '' },
                    GruvboxGreenSign = { fg = '#b8bb26', bg = '' },
                    GruvboxRedSign = { fg = '#fb4934', bg = '' },
                    GruvboxBlueSign = { fg = '#83a598', bg = '' },
                    WilderMenu = { fg = '#ebdbb2', bg = '' },
                    WilderAccent = { fg = '#f4468f', bg = '' },
                    -- coc semantic token
                    CocSemStruct = { link = 'GruvboxYellow' },
                    CocSemKeyword = { fg = '', bg = '#0E1018' },
                    CocSemEnumMember = { fg = '', bg = '#0E1018' },
                    CocSemTypeParameter = { fg = '', bg = '#0E1018' },
                    CocSemComment = { fg = '', bg = '#0E1018' },
                    CocSemMacro = { fg = '', bg = '#0E1018' },
                    CocSemVariable = { fg = '', bg = '#0E1018' },
                    -- CocSemFunction = {link = "GruvboxGreen"},
                    -- neorg
                    ['@neorg.markup.inline_macro'] = { link = 'GruvboxGreen' },
                },
            })
            vim.cmd.colorscheme('gruvbox')
        end,
    },
})

local commands = {}

--- --- Provides user commands for editing Hammerspoon configuration files
--- --- ===================================================================
--- --- The user commands "Config" and "ConfigHs" can be used to open the configuration
--- --- files for Hammerspoon applications in a new buffer. The paths are fetched from
--- --- Hammerspoon (apps[appname].paths.defaults.config).
--- ---
--- --- Fetch the path to the configuration file for a given Hammerspoon application
--- local function fetch_config_path(alias, key)
---     local hs_cmd = 'hs.inspect(apps.' .. alias .. '.paths.' .. key .. ')'
---     local path = vim.fn.system('hs -q -c \'' .. hs_cmd .. '\'')
---     -- Be sure it is a path
---     -- trim quotes
---     path = string.gsub(path, '"', '')
---     -- Verify string is a path
---     if path.match(path, '^/.+') then
---         return path
---     else
---         return nil
---     end
--- end
---
--- --- Fetch the aliases of the configured Hammerspoon applications
--- local function fetch_apps()
---     local apps_config =
---         vim.fn.system('hs -c \'for k, v in pairs(apps) do print(k) end\'')
---     local apps_config_keys = vim.split(apps_config, '\n')
---     -- replace \n with empty string in each item of the table apps_config_keys
---     local apps = {}
---     for _, app in ipairs(apps_config_keys) do
---         local alias =
---             vim.fn.system('hs -c \'hs.inspect(apps.' .. app .. '.alias)\'')
---         -- filter out strings that starts with "\"[a-zA-Z]+\""
---         alias = string.match(alias, '"([a-zA-Z]+)"', 1)
---         table.insert(apps, alias)
---     end
---     return apps
--- end
--
-- --- Fetch completions from Hammerspoon
-- M.completions = fetch_apps()
--
-- --- User commands
-- --- :Config <alias> - Open the configuration file for the given alias
-- vim.api.nvim_create_user_command("Config", function(args)
--     local alias = args.args
--     local config_path = fetch_config_path(alias, "config"):gsub("\n", "")
--     local is_folder = vim.fn.isdirectory(config_path)
--     if config_path and has_telescope then
--         if has_telescope then
--             require("telescope.builtin").find_files({
--                 search_dirs = { config_path },
--                 ignore_files = { "-lock.json" },
--             })
--         else
--             vim.cmd("edit " .. config_path)
--         end
--     else
--         vim.notify("No config path found for " .. alias)
--     end
-- end, {
--     nargs = 1, -- means that the command takes one argument (the alias)
--     -- add completions from configs module .completions
--     complete = function(_, _, _, _, _, _)
--         return require("user.commands.configs").completions
--     end,
-- })
--
-- --- :ConfigHs <alias> - Open the Hammerspoon configuration file for the given alias
-- vim.api.nvim_create_user_command("ConfigHs", function(args)
--     local alias = args.args
--     local config_path = require("user.commands.configs").fetch_config_path(alias, "config_hs")
--     if config_path then
--         vim.cmd("edit " .. config_path)
--     else
--         vim.notify("No config path found for " .. alias)
--     end
-- end, {
--     nargs = 1,
--     -- add completions from configs module .completions
--     complete = function(_, _, _, _, _, _)
--         return require("user.commands.configs").completions
--     end,
-- })
--
-- test url: [Google](https://www.google.com)
local function fetch_url_title(url)
    -- Bail early if the url obviously isn't a URL.
    if not string.match(url, '^https?://') then
        return ''
    end

    -- Use os.execute to get link's page title.
    local cmd = 'curl -sL ' .. vim.fn.shellescape(url) .. ' 2>/dev/null'
    local handle = io.popen(cmd)
    if not handle then
        return
    end
    local html = handle:read('*a')
    handle:close()
    local pattern = '<title>(.-)</title>'
    local m = string.match(html, pattern)
    if m then
        return m
    end
end

local function put_markdown_link()
    vim.cmd('normal! yiW')
    local url = tostring(vim.fn.getreg('')) or ''
    if url == '' then
        vim.notify('No URL found under the cursor')
        return
    elseif not string.match(url, '^https?://') then
        vim.notify(url .. ' doesn\'t look like a URL')
        return
    end

    -- Fetch the title of the URL.
    local title = fetch_url_title(url)
    if title ~= '' then
        local link = string.format('[%s](%s)', title, url)
        vim.fn.setreg('', link)
        vim.cmd('normal! viWp')
    else
        print('Title not found for link')
    end
end

vim.api.nvim_create_user_command('PutMarkdownLink', put_markdown_link, {
    nargs = 0,
})

-- Make a keybinding (mnemonic: "mark down paste")
vim.keymap.set(
    'n',
    '<leader>mdp',
    put_markdown_link,
    { silent = true, noremap = true }
)

-- function commands.todo()
--     local todoist_api_key = os.getenv('TODOIST_API_KEY')
--     local url = 'https://api.todoist.com/rest/v2/tasks'
--     local headers = {
--         ['Content-Type'] = 'application/json',
--         ['Authorization'] = 'Bearer ' .. todoist_api_key,
--     }
--     local response = vim.fn.system(
--         string.format(
--             'curl -s -H \'Content-Type: application/json\' -H \'Authorization: Bearer %s\' -X POST -d \'%s\' %s',
--             todoist_token,
--             body,
--             url
--         )
--     )
--     print(response)
-- end

---@command :Todo [[
---Fetch list of tasks from todoist api
---@command ]]
vim.api.nvim_create_user_command('Todo', function()
    commands.todo()
end, {})

---Reorders lines in a buffer to move dataview query lines after frontmatter.
---@param bufnr number Buffer handle
---@return nil
local function replace_dataview_query(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local matched_lines = {} ---@type string[]
    local non_matched_lines = {} ---@type string[]
    local has_frontmatter = lines[1] == '---'
    local start_line = has_frontmatter and 1 or 0

    for _, line in ipairs(lines) do
        if line:match('^[a-z_-]+::.*$') then
            table.insert(matched_lines, line)
        else
            table.insert(non_matched_lines, line)
        end
    end

    if has_frontmatter then
        table.remove(matched_lines, 1)
        for i, line in ipairs(matched_lines) do
            table.insert(non_matched_lines, start_line + i, line)
        end
        matched_lines = non_matched_lines
    else
        for _, line in ipairs(non_matched_lines) do
            table.insert(matched_lines, line)
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, matched_lines)

    return nil
end

vim.api.nvim_create_user_command('RDvQuery', replace_dataview_query, {})

local build_commands = {
    c = 'g++ -std=c++17 -o %:p:r.o %',
    cpp = 'g++ -std=c++17 -o %:p:r.o %',
    rust = 'cargo build --release',
    go = 'go build -o %:p:r.o %',
}

local whoami = vim.fn.system('whoami')
local qmk_build_command = 'qmk compile -kb idobao/id75/v2 -km ' .. whoami

local debug_build_commands = {
    c = 'g++ -std=c++17 -g -o %:p:r.o %',
    cpp = 'g++ -std=c++17 -g -o %:p:r.o %',
    rust = 'cargo build',
    go = 'go build -o %:p:r.o %',
}

local run_commands = {
    c = '%:p:r.o',
    cpp = '%:p:r.o',
    rust = 'cargo run --release',
    go = '%:p:r.o',
    py = 'python3 %',
    sh = 'zsh %',
    js = 'node %',
    applescript = 'osascript "%"',
}

--- --- @diagnostic disable-next-line: unused-function
--- --- @diagnostic disable-next-line: unused-local
--- local function execute_osascript(script)
---     local command = string.format('osascript -e \'%s\'', script)
---     vim.cmd(string.format('!%s', command))
--- end

-- Assign commands

-- "Build" to build current file
vim.api.nvim_create_user_command('Build', function()
    local filetype = vim.bo.filetype
    for file, command in pairs(build_commands) do
        -- if parent dir of current file contains "qmk_firmware" then use qmk build command
        if string.find(vim.fn.expand('%:p:h'), 'qmk_firmware') then
            vim.cmd('!' .. qmk_build_command)
            break
        end
        if filetype == file then
            vim.cmd('!' .. command)
            break
        end
    end
end, {})

-- "DebugBuild" to build current file with debug symbols
vim.api.nvim_create_user_command('DebugBuild', function()
    local filetype = vim.bo.filetype
    for file, command in pairs(debug_build_commands) do
        if filetype == file then
            vim.cmd('!' .. command)
            break
        end
    end
end, {})

-- "Run" to run current file
vim.api.nvim_create_user_command('Run', function()
    local filetype = vim.bo.filetype
    for file, command in pairs(run_commands) do
        if filetype == file then
            command = string.gsub(command, '%%', vim.fn.expand('%')) -- replace % with current file path
            vim.notify(vim.fn.system(command))
            break
        end
    end
end, {})

-- "Run" to run jsx script in photoshop
vim.api.nvim_create_user_command('RunPhotoshop', function()
    local cmd =
    'silent exec \'!osascript -e "tell application \\"Adobe Photoshop 2023\\"  to do javascript of file \\"%s\\""\''
    cmd = string.format(cmd, vim.fn.expand('%:p'))
    vim.cmd(cmd)
end, {})

-- "RunPhotoshopScript" to run current file in Photoshop
vim.api.nvim_create_user_command('RunPsScript', function()
    local photoshop_name = vim.fn.system('hs -c \'apps.photoshop.name\'')
    -- execute_osascript('\'tell application ' .. photoshop_name .. 'to do javascript of file "%"\'')
    vim.fn.system(
        'osascript -e \'tell application '
        .. photoshop_name
        .. ' to do javascript of file "%"\''
    )
end, {
    nargs = 1,
    complete = function()
        local app_scripts_dir =
            vim.fn.system('hs -c \'apps.photoshop.paths.scripts\'')
        -- Reursively find all files in app_scripts_dir
        -- mdfind -onlyin app_scripts_dir "kMDItemFSName == '*.*' && kMDItemKind != 'Folder'"
        local paths = vim.fn.system('find ' .. app_scripts_dir)
        -- Split files by newlines
        local paths_table = vim.split(paths, '\n')
        -- Remove directories
        local files = {}
        for _, path in pairs(paths_table) do
            if vim.fn.isdirectory(path) == 0 then
                -- Remove app_scripts_dir from start of path
                local file = string.sub(path, string.len(app_scripts_dir) + 1)
                if file ~= '' then
                    -- Remove app_scripts_dir from path
                    table.insert(files, file)
                end
            end
        end
        return files
    end,
})

-- "UUID" to generate UUID and put in to register
vim.api.nvim_create_user_command('UUID', function()
    local uuid = vim.fn.system('uuidgen')
    uuid = uuid:gsub('-', ''):lower():gsub('%z', ''):gsub('\n', '')
    vim.api.nvim_put({ uuid }, 'c', true, true)
end, {})

-- "BuildAndRun" to build and run current file
vim.api.nvim_create_user_command('BuildAndRun', function()
    vim.cmd([[Build]])
    vim.cmd([[Run]])
end, {})

local Path = require('plenary.path')
run_commands = {
    dev = 'npm run tauri dev',
    build = 'npm run tauri build',
}

-- Initialize an empty table for the Tauri package.
package.loaded.tauri = {}

--- Get the Tauri project root directory.
--- Stores the Tauri project root in the global variable package.loaded.tauri.root.
local function get_tauri_root()
    local dir = vim.fn.expand('%:p:h')
    local path = Path:new(dir)
    -- Only call this function again if the current buffer is in a different Tauri project directory.
    if
        package.loaded.tauri.root
        and package.loaded.tauri.root == path.filename
    then
        return package.loaded.tauri.root
    end
    -- Iterate through parent directories until reaching the root directory ('/')
    while path.filename ~= '/' do
        if Path:new(path.filename, 'src-tauri'):exists() then
            package.loaded.tauri.root = path.filename
            return package.loaded.tauri.root
        end
        -- Move to the parent directory
        path = path:parent()
    end
    package.loaded.tauri.root = nil
end

--- Check if the current directory is a Tauri project.
local function is_tauri_project()
    -- Call get_tauri_root() to ensure the global variable package.loaded.tauri.root is set.
    get_tauri_root()
    if package.loaded.tauri.root == nil then
        vim.notify('Not a Tauri project', vim.log.levels.ERROR)
        return false
    end
    return true
end

--- Change the current directory to the Tauri project root.
local function cd_to_tauri_root()
    -- cd to the Tauri project root
    vim.cmd('cd ' .. get_tauri_root())
end

--- Change the current directory to the Tauri project frontend directory.
local function cd_to_tauri_frontend()
    -- cd to the Tauri project frontend directory
    vim.cmd('cd ' .. get_tauri_root() .. '/src')
end

--- Change the current directory to the Tauri project backend directory.
local function cd_to_tauri_backend()
    -- cd to the Tauri project backend directory
    vim.cmd('cd ' .. get_tauri_root() .. '/src-tauri/src')
end

--- TauriDev user command to run Tauri development server.
vim.api.nvim_create_user_command('TauriDev', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_root()
    vim.cmd('split | terminal ' .. run_commands.dev)
end, {})

--- TauriBuild user command to build a Tauri project.
vim.api.nvim_create_user_command('TauriBuild', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_root()
    vim.cmd('split | terminal ' .. run_commands.build)
end, {})

--- TauriFrontend user command to search Tauri project frontend files.
vim.api.nvim_create_user_command('TauriFrontend', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_frontend()
    require('telescope.builtin').find_files({
        prompt_title = 'Tauri Frontend',
        cwd = get_tauri_root() .. '/src',
    })
end, {})

--- TauriBackend user command to search Tauri project backend files.
vim.api.nvim_create_user_command('TauriBackend', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    require('telescope.builtin').find_files({
        prompt_title = 'Tauri Backend',
        cwd = get_tauri_root() .. '/src-tauri/src',
    })
end, {})

--- TauriConfig user command to open Tauri project configuration file.
vim.api.nvim_create_user_command('TauriConfig', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    vim.cmd('e ' .. get_tauri_root() .. '/src-tauri/tauri.conf.json')
end, {})

--- TauriCargo user command to open Tauri project Cargo.toml file.
vim.api.nvim_create_user_command('TauriCargo', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    vim.cmd('e ' .. get_tauri_root() .. '/src-tauri/Cargo.toml')
end, {})

--- TauriMain user command to open Tauri project main.rs file.
vim.api.nvim_create_user_command('TauriMain', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    vim.cmd('e ' .. get_tauri_root() .. '/src-tauri/src/main.rs')
end, {})
run_commands = {
    dev = 'npm run tauri dev',
    build = 'npm run tauri build',
}

-- Initialize an empty table for the Tauri package.
package.loaded.tauri = {}

--- TauriDev user command to run Tauri development server.
vim.api.nvim_create_user_command('TauriDev', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_root()
    vim.cmd('split | terminal ' .. run_commands.dev)
end, {})

--- TauriBuild user command to build a Tauri project.
vim.api.nvim_create_user_command('TauriBuild', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_root()
    vim.cmd('split | terminal ' .. run_commands.build)
end, {})

--- TauriFrontend user command to search Tauri project frontend files.
vim.api.nvim_create_user_command('TauriFrontend', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_frontend()
    require('telescope.builtin').find_files({
        prompt_title = 'Tauri Frontend',
        cwd = get_tauri_root() .. '/src',
    })
end, {})

--- TauriBackend user command to search Tauri project backend files.
vim.api.nvim_create_user_command('TauriBackend', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    require('telescope.builtin').find_files({
        prompt_title = 'Tauri Backend',
        cwd = get_tauri_root() .. '/src-tauri/src',
    })
end, {})

--- TauriConfig user command to open Tauri project configuration file.
vim.api.nvim_create_user_command('TauriConfig', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    vim.cmd('e ' .. get_tauri_root() .. '/src-tauri/tauri.conf.json')
end, {})

--- TauriCargo user command to open Tauri project Cargo.toml file.
vim.api.nvim_create_user_command('TauriCargo', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    vim.cmd('e ' .. get_tauri_root() .. '/src-tauri/Cargo.toml')
end, {})

--- TauriMain user command to open Tauri project main.rs file.
vim.api.nvim_create_user_command('TauriMain', function()
    if is_tauri_project() == false then
        return
    end
    -- cd to the Tauri project root
    cd_to_tauri_backend()
    vim.cmd('e ' .. get_tauri_root() .. '/src-tauri/src/main.rs')
end, {})

local file_patterns = {
    zsh = {
        '*.zshrc',
        '*.env',
        '*.aliases',
        '*.exports',
        '*.functions',
        '*.zsh-theme',
        '*.secrets',
    },
    javascript = {
        '*.psjs',
        '*.js',
    },
    applescript = {
        '*.applescript',
        '*.scpt',
        '*.scptd',
    },
}

-- Create a single autocmd group for all file patterns
local augroup_filetype =
    vim.api.nvim_create_augroup('setFiletype', { clear = true })

-- Function to set filetype based on file patterns
local function set_filetype(filetype, patterns)
    vim.api.nvim_create_autocmd('BufReadPost', {
        pattern = table.concat(patterns, ','),
        group = augroup_filetype,
        command = 'set filetype=' .. filetype,
    })
end

-- Set filetypes for all file patterns
for filetype, patterns in pairs(file_patterns) do
    if filetype == 'applescript' then
        -- Special case for applescript filetype
        vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
            pattern = table.concat(patterns, ','),
            group = augroup_filetype,
            command = 'set filetype=applescript | set tabstop=4 | set shiftwidth=4 | set expandtab',
        })
    else
        set_filetype(filetype, patterns)
    end
end

-- Optimize yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = augroup_filetype,
    command = 'silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=25})',
})

-- Navigation
vim.keymap.set({ 'n', 'v' }, '<up>', function()
    vim.u.utils.jump_to_next_line_with_same_indent(false, { 'end', '-' })
end, { desc = 'move to previous line with same indentation' })
vim.keymap.set({ 'n', 'v' }, '<down>', function()
    vim.u.utils.jump_to_next_line_with_same_indent(true, { 'end', '-' })
end, { desc = 'move to next line with same indentation' })
--
vim.keymap.set('n', '<left>', '<C-w>h')
vim.keymap.set('n', '<right>', '<C-w>l')
--
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { desc = 'move line up' })
vim.keymap.set('v', 'K', ':m \'>-2<CR>gv=gv', { desc = 'move line down' })
vim.u.fn = {}

--- Generate a new UUID.
---
---@return string uuid: The generated UUID
local function generate_uuid()
    local random = math.random
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    local uuid = string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
    return uuid
end

--- Format a UUID by lowercasing and removing invalid characters.
---
---@param uuid string The UUID to format
---@return string formatted: The formatted UUID
local function format_uuid(uuid)
    uuid = uuid:gsub('[%w]', string.lower)
    uuid = uuid:gsub('[^%w]', '')
    return uuid
end

--- Generate and format a UUID.
---
---@return string uuid: The formatted UUID
function vim.u.fn.generate_formatted_uuid()
    local uuid = generate_uuid()
    uuid = format_uuid(uuid)

    return uuid
end

---Put UUID in register
---@description Generate UUID and put it in register
---@usage functions.put_uuid()
---@return nil:
function vim.u.fn.put_uuid()
    local uuid = vim.u.fn.generate_formatted_uuid()
    vim.api.nvim_put({ uuid }, 'c', true, true)
end

---Toggle VimShell terminal window (:VimShell)
---@description If terminal in any split is open, close it. If terminal is closed, open it in current split with (:vsplit | VimShell)
---@usage functions.toggle_terminal()
---@return nil
function vim.u.fn.toggle_terminal()
    local terminal = 'vimshell'
    local is_buf_exist = function()
        local buf_exist = false
        local shell_buf = vim.fn.bufnr(terminal) -- get vimshell buffer number
        if shell_buf ~= -1 then
            buf_exist = true
            return buf_exist
        end
        return buf_exist
    end
    local is_focused = function()
        local focused = false
        local current_win = vim.fn.win_getid()           -- get current window id
        local current_buf = vim.fn.winbufnr(current_win) -- get current buffer number
        local shell_buf = vim.fn.bufnr(terminal)         -- get vimshell buffer number
        if current_buf == shell_buf then
            focused = true
            return focused
        end
        return focused
    end

    local is_split_exist = function()
        local split_exist = false
        local shell_buf = vim.fn.bufnr(terminal)     -- get vimshell buffer number
        local shell_win = vim.fn.bufwinid(shell_buf) -- get vimshell window id
        if shell_win ~= -1 then
            split_exist = true
            return split_exist
        end
        return split_exist
    end

    if is_buf_exist() then
        if is_split_exist() then
            if is_focused() then
                vim.cmd('q')
            else
                vim.cmd('wincmd p')
                vim.cmd('q')
            end
            return
        end
        vim.cmd('vsplit | VimShell')
    else
        vim.cmd('vsplit | VimShell')
    end
end

-- ---Exit VimShell terminal window (:VimShellPop)
-- ---@description Exit VimShell terminal window (:VimShellPop)
-- ---@usage functions.close_terminal()
-- function vim.u.fn.close_terminal()
--     -- functions.close_terminal()
--     -- Function
--     -- Exit VimShell terminal window (:VimShellPop)
--     -- Parameters:
--     -- * None
--     -- Usage:
--     -- * <leader>te
--
--     -- find buffer with terminal
--     local terminal = 'vimshell'
--     -- local buffers = vim.api.nvim_list_bufs()
--     local is_exist = function(buf)
--         -- Function
--         -- Check if buffers vimshell is exists in buffers
--         -- Parameters:
--         -- * buf: buffer number
--
--         -- Return: boolean
--         return vim.fn.bufname(buf) == terminal -- bufname returns buffer name by number (buf)
--     end
--     -- local is_focused = function(buf)
--     -- Function
--     -- Check if buffer vimshell is focused
--     -- Parameters:
--     -- * buf: buffer number
--
--     -- Return: boolean
--     -- return vim.api.nvim_win_get_buf(0) == buf -- get current buffer number in current window and compare it with buffer number of vimshell buffer
--     -- end
--     if is_exist(vim.fn.bufnr(terminal)) then -- if vimshell is exists
--         vim.cmd('b ' .. terminal) -- focus it
--         vim.cmd('q') -- close it
--         return
--     else
--         return
--     end
-- end

---Open VimShell in floating window
---@description Open VimShell in floating window
---@usage functions.open_terminal()
---@return nil
function vim.u.fn.open_terminal()
    -- functions.open_terminal()
    -- Function
    -- Open VimShell in floating window
    -- Parameters:
    -- * None
    -- Usage:
    -- * <leader>to

    local win = vim.fn.win_getid()
    local term = vim.fn.win_gettype(win)
    if term == 'terminal' then
        vim.cmd('q')
    else
        vim.cmd('VimShell')
    end
end

---place M to fn
vim.u.fn = vim.u.fn

function vim.u.fn.write_then_source()
    vim.cmd('write')
    local filetype = vim.bo.filetype
    if filetype == 'lua' then
        local current_path = vim.fn.expand('%:p')
        if type(current_path) ~= 'string' then
            return
        end
        if current_path:find('config/hammerspoon') ~= nil then
            vim.execute('hs -c "hs.reload()"')
        else
            vim.cmd('luafile %')
        end
        vim.cmd('source %')
    end
end

vim.keymap.set('n', '<leader>xx', function()
    vim.u.fn.write_then_source()
end, { desc = 'write and source current file' })

-- reltimestr({time})                                                *reltimestr()*
-- 		Return a String that represents the time value of {time}.
-- 		This is the number of seconds, a dot and the number of
-- 		microseconds.  Example: >vim
-- 			let start = reltime()
-- 			call MyFunction()
-- 			echo reltimestr(reltime(start))
-- <		Note that overhead for the commands will be added to the time.
-- 		Leading spaces are used to make the string align nicely.  You
-- 		can use split() to remove it. >vim
-- 			echo split(reltimestr(reltime(start)))[0]
-- <		Also see |profiling|.
-- 		If there is an error an empty string is returned
local function measure_time(func)
    local start = vim.fn.reltime()
    func()
    local str = vim.fn.reltimestr(vim.fn.reltime(start))
    return str
end

--- Measure execution time of a function.
---
---@param name string: The name of the function
---@param func function: The function to benchmark
---@return nil
function vim.u.fn.benchmark(name, func)
    local time_str = measure_time(func)
    vim.api.nvim_echo({ { time_str .. ' ' .. name, 'String' } }, true, {})
end

B = vim.u.fn.benchmark
vim.u.format = {}
vim.u.format.lua = {}

local function convert_lines(lines, from_pattern, to_format)
    local new_lines = {}
    for _, line in ipairs(lines) do
        if string.match(line, from_pattern) then
            local func_name, args = string.match(line, from_pattern)
            local new_line = string.format(to_format, func_name, args)
            table.insert(new_lines, new_line)
        else
            table.insert(new_lines, line)
        end
    end
    return new_lines
end

--- Converts local module functions to public functions
--- @param buf number Buffer handle
--- @param start_line integer Start line
--- @param end_line integer End line
--- @return string[] Modified lines
function vim.u.format.lua.function_from_local_to_public(
    buf,
    start_line,
    end_line
)
    --- @type string[]
    local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)

    --- @type string
    local pattern = '^function M%.([a-zA-Z0-9_]+)%((.*)%)$'

    --- @type string
    local to_format = 'M.%s = function(%s)'

    --- @type string[]
    local new_lines = convert_lines(lines, pattern, to_format)

    vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, new_lines)

    --- @type string[]
    return new_lines
end

function vim.u.format.lua.function_from_public_to_local(
    buf,
    start_line,
    end_line
)
    local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
    local pattern = '^M%.([a-zA-Z0-9_]+) = function(%(.*%)$'
    local to_format = 'function M.%s(%s)'
    local new_lines = convert_lines(lines, pattern, to_format)
    vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, new_lines)
    return new_lines
end

function vim.u.format.lua.convert_function()
    local buf = 0
    local start_line = vim.fn.getpos('.')[2] - 1
    local end_line = vim.fn.getpos('.')[2]
    local line = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)[1]
    if string.match(line, '^function M%.') then
        vim.u.format.lua.function_from_local_to_public(
            buf,
            start_line,
            end_line
        )
    elseif string.match(line, '^M%.') then
        vim.u.format.lua.function_from_public_to_local(
            buf,
            start_line,
            end_line
        )
    end
end

vim.cmd('colorscheme catppuccin')
