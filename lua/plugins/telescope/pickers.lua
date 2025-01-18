local M = {}
local actions = require('telescope.actions')
local entry_makers = require('plugins.telescope.entry_makers')
local config = require('telescope.config')
local pickers = require('telescope.pickers')

---@type TelescopLayout
local layout
local desc = 'Telescope Layout'

vim.keymap.set('n', '<leader>ba', function()
    M.browse_assets()
end, { desc = 'Browse Assets' })

vim.keymap.set('n', '<leader>in', function()
    M.grep_notes_without_tags()
end, { desc = 'grep in Knowledge folder, ignoring hidden files' })

-- vim.keymap.set('n', '<leader>r', function()
--     M.fetch_list_of_repos()
-- end, { desc = 'fetch list of repos' })

vim.keymap.set('n', '<leader>P', function()
    M.browse_projects()
end, { desc = 'browse projects' })

vim.keymap.set('n', '<leader>p', function()
    M.choose_picker()
end, { desc = 'telescope pickers' })
vim.keymap.set('n', '<leader>o', function()
    M.open_file_in_workspace()
end, { desc = 'open file from project' })

vim.keymap.set('n', '<leader>O', function()
    M.open_file_from_home()
end, { desc = 'open file from project in vertical split' })

vim.keymap.set('n', '<leader>gw', function()
    M.grep_across_workspace()
end, { desc = 'grep across workspace' })

vim.keymap.set('n', '<leader>gh', function()
    M.grep_cword_in_help_tags()
end, { desc = 'grep cword in help' })

vim.keymap.set('v', '<leader>gh', function()
    M.grep_visual_selection_in_help_tags()
end, { desc = 'grep visual selection in help' })

---@table package
local telescope = package.loaded['telescope']
local themes = require('telescope.themes')
local layouts = require('plugins.telescope.layouts')

---Choose a picker
---@usage :lua require('plugins.telescope.custom_pickers').choose_picker()
function M.choose_picker()
    require('telescope.builtin').builtin({
        cwd = require('config.utils.directory').get_root_dir(),
        hidden = false,
        follow = true,
        search_dirs = { require('config.utils.directory').get_root_dir() },
        create_layout = layouts.compact,
    })
end

---Open a file in the current working directory
---@description Opens a file using telescope in the current working directory
---@usage :lua require('plugins.telescope.custom_pickers').open_file()
function M.open_file_in_workspace()
    require('telescope.builtin').find_files({
        cwd = require('config.utils.directory').get_root_dir(),
        hidden = false,
        follow = true,
        search_dirs = { require('config.utils.directory').get_root_dir() },
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            prompt_position = 'top',
            preview_height = 0.5,
        },
    })
end

---Open a file from home
---@description Opens a file using telescope in the home directory
---@usage :lua require('plugins.telescope.custom_pickers').open_file_from_home()
function M.open_file_from_home()
    require('telescope.builtin').find_files({
        cwd = '~',
        hidden = false,
        follow = true,
        find_command = {
            -- set max-depth to 3 to avoid searching in node_modules
            'fd',
            '--type',
            'f',
            '--hidden',
            '--follow',
            '--exclude',
            'node_modules',
            '--max-depth',
            '3',
        },

        search_dirs = { '~' },
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            prompt_position = 'top',
            preview_height = 0.5,
        },
    })
end

local previewers = require('telescope.previewers')

---Grep across the current working directory
---@description Greps across the current working directory
---@usage :lua require('plugins.telescope.custom_pickers').grep_across_workspace()
function M.grep_across_workspace()
    -- Get the directory of the current file
    local dir = vim.fn.expand('%:p:h')

    -- vim.uv.chdir(dir)
    if dir == '' then
        dir = vim.fn.getcwd()
    end
    vim.cmd('cd ' .. dir)

    vim.schedule(function()
        require('telescope.builtin').live_grep({
            create_layout = layouts.live_grep,
            entry_maker = entry_makers.gen_from_live_grep,
            cwd = require('config.utils.directory').get_root_dir(),
            hidden = false,
            follow = true,
            search_dirs = { require('config.utils.directory').get_root_dir() },
            -- Add additional options for better performance
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--hidden',
            },
            -- Use a more efficient sorter
            sorter = require('telescope.sorters').get_fzy_sorter(),
        })
    end)
end

---Grep current word in the current working directory
---@description Greps current word in the current working directory
---@usage :lua require('plugins.telescope.custom_pickers').grep_cword_in_workspace()
---@see
function M.grep_cword_in_workspace()
    local word = vim.fn.expand('<cword>')
    require('telescope.builtin').live_grep({
        cwd = require('config.utils.directory').get_root_dir(),
        hidden = false,
        follow = true,
        search_dirs = { require('config.utils.directory').get_root_dir() },
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
        default_text = word,
    })
end

vim.keymap.set('n', '<leader>*', function()
    M.grep_cword_in_workspace()
end, { desc = 'grep cword in workspace' })

---Grep visual selection in the current working directory
---@description Greps visual selection in the current working directory
---@usage :lua require('plugins.telescope.custom_pickers').grep_visual_selection_in_workspace()
---@see
function M.grep_visual_selection_in_workspace()
    local visual_selection =
        require('config.utils.directory').get_visual_selection()
    require('telescope.builtin').live_grep({
        cwd = require('config.utils.directory').get_root_dir(),
        hidden = false,
        follow = true,
        search_dirs = { require('config.utils.directory').get_root_dir() },
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
        default_text = visual_selection,
    })
end

vim.keymap.set('v', '<leader>*', function()
    M.grep_visual_selection_in_workspace()
end, { desc = 'grep visual selection in workspace' })

---Grep in help_tags
---@description Greps in help_tags
---@usage :lua require('plugins.telescope.custom_pickers').grep_in_help_tags()
function M.grep_in_help_tags()
    require('telescope.builtin').help_tags({
        cwd = vim.fn.stdpath('data') .. '/doc',
        hidden = false,
        follow = true,
        search_dirs = { vim.fn.stdpath('data') .. '/doc' },
        layout_strategy = 'vertical',
        layout_config = {
            height = 0.9,
            mirror = false,
            prompt_position = 'top',
            preview_height = 0.8,
        },
    })
end

---Grep current word in help_tags
---@description Greps current word in help_tags
---@usage :lua require('plugins.telescope.custom_pickers').grep_cword_in_help_tags()
function M.grep_cword_in_help_tags()
    local word = vim.fn.expand('<cword>')
    require('telescope.builtin').help_tags({
        hidden = false,
        search_dirs = { vim.fn.stdpath('data') .. '/doc' },
        layout_strategy = 'vertical',
        layout_config = {
            height = 0.9,
            mirror = false,
            prompt_position = 'top',
            preview_height = 0.8,
        },
        default_text = word,
    })
end

---Grep visual selection in help_tags
---@description Greps visual selection in help_tags
---@usage :lua require('plugins.telescope.custom_pickers').grep_visual_selection_in_help()
function M.grep_visual_selection_in_help_tags()
    local visual_selection =
        require('config.utils.directory').get_visual_selection()
    require('telescope.builtin').help_tags({
        layout_strategy = 'vertical',
        layout_config = {
            height = 0.9,
            mirror = false,
            prompt_position = 'top',
            preview_height = 0.8,
        },
        grep_open_files = true,
        default_text = visual_selection,
    })
end

---Grep in current buffer
---@description Greps in current buffer
---@usage :lua require('plugins.telescope.custom_pickers').grep_in_current_buffer()
function M.grep_in_current_buffer()
    require('telescope.builtin').current_buffer_fuzzy_find({
        cwd = require('config.utils.directory').get_root_dir(),
        hidden = false,
        follow = true,
        search_dirs = { require('config.utils.directory').get_root_dir() },
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            prompt_position = 'top',
            preview_height = 0.5,
        },
    })
end

vim.keymap.set('n', '<leader>/', function()
    M.grep_in_current_buffer()
end, { desc = 'grep in current buffer' })

---Go to definition
function M.goto_definition()
    require('telescope.builtin').lsp_definitions({
        prompt_title = 'Go to Definition',
    })
end

vim.keymap.set('n', 'gI', function()
    M.goto_definition()
end, { desc = 'go to definition' })

vim.api.nvim_create_user_command('GotoDefinition', function()
    M.goto_definition()
end, {
    nargs = '*',
    complete = 'customlist,v:lua._telescope.builtin_commands',
})

function M.goto_definition_from_visual_selection()
    local visual_selection =
        require('config.utils.directory').get_visual_selection()
    require('telescope.builtin').lsp_definitions({
        prompt_title = 'Go to Definition',
        default_text = visual_selection,
    })
end

vim.keymap.set('v', 'gdv', function()
    M.goto_definition_from_visual_selection()
end, { desc = 'go to definition from visual selection' })

function M.goto_definition_with_vertical_split()
    vim.cmd('vsplit')
    M.goto_definition()
end

vim.keymap.set('n', '<leader>gdv', function()
    M.goto_definition_with_vertical_split()
end, { desc = 'go to definition with vertical split' })

function M.goto_definition_with_horizontal_split()
    vim.cmd('split')
    M.goto_definition()
end

vim.keymap.set('n', '<leader>gds', function()
    M.goto_definition_with_horizontal_split()
end, { desc = 'go to definition with horizontal split' })

function M.search_for_repositories()
    -- TODO: Add a prompt to choose the search engine
end

function M.find_files_in_knowledge_base()
    require('telescope.builtin').live_grep({
        prompt_title = 'Find Files in Knowledge Base',
        cwd = '~/Knowledge',
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
    })
end

function M.browse_files()
    telescope.extensions.file_browser.file_browser({
        title = 'Browse Files',
        path_display = { 'smart' },
        cwd = '~',
        layout_strategy = 'horizontal',
        layout_config = { preview_width = 0.65, width = 0.75 },
        hidden = true, -- Show hidden files
        dir_icon = '▪', -- Set the directory icon
        dir_icon_hl = 'TelescopeFileBrowserDirIcon', -- Set the directory icon highlight group
        grouped = true, -- Group files by extension
    })
end

vim.keymap.set('n', '<leader>E', function()
    M.browse_files()
end, { desc = 'Blazing fast file browser in whole home' })

function M.browse_files_in_project()
    local root_dir = M.find_project_root()
    if root_dir == nil then
        print('No project root found')
        return
    end
    telescope.extensions.file_browser.file_browser({
        title = 'Browse Files',
        path_display = { 'smart' },
        cwd = root_dir,
        layout_strategy = 'horizontal',
        layout_config = { preview_width = 0.65, width = 0.75 },
        hidden = true, -- Show hidden files
        dir_icon = '▪', -- Set the directory icon
        dir_icon_hl = 'TelescopeFileBrowserDirIcon', -- Set the directory icon highlight group
        grouped = true, -- Group files by extension
    })
end

function M.grep_inside_project()
    local root_dir = require('config.utils.directory').get_root_dir()
    require('telescope.builtin').live_grep({
        prompt_title = 'Search Inside Project',
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
        cwd = root_dir,
        hidden = false,
    })
end

vim.keymap.set('n', '<leader>ip', function()
    M.grep_inside_project()
end, { desc = 'Grep inside current project' })

--- Greps inside the current project for a specific function.
-- TODO: Use LSP to find the function definitions
function M.grep_functions_inside_project()
    require('telescope.builtin').live_grep({
        prompt_title = 'Find Function in Project',
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
        -- additional_args = patterns(),
        search_dirs = { M.find_project_root() },
    })
end

vim.keymap.set('n', '<leader>ipf', function()
    M.grep_functions_inside_project()
end, { desc = 'grep in project' })

function M.grep_todos_inside_project()
    require('telescope.builtin').live_grep({
        title = 'TODOs',
        prompt_prefix = 'TODO: ',
        search = 'TODO',
        cwd = M.find_project_root(),
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
    })
end

vim.keymap.set('n', '<leader>iptd', function()
    M.grep_todos_inside_project()
end, { desc = 'grep in project' })

function M.grep_inside_knowledge()
    require('telescope.builtin').live_grep({
        prompt_title = 'Searching Inside Knowledge Base',
        search_dirs = { '~/Knowledge' },
        hidden = false,
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
        path_display = { 'smart' },
    })
end

vim.keymap.set('n', '<leader>ik', function()
    M.grep_inside_knowledge()
end, { desc = 'grep in Knowledge folder, ignoring hidden files' })

function M.grep_todos_inside_knowledge()
    require('telescope.builtin').live_grep({
        title = 'TODOs',
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
        prompt_prefix = 'TODO: ',
        path_display = { 'smart' },
        search = '- [ ]',
        search_dirs = { '~/Knowledge' },
    })
end

vim.keymap.set('n', '<leader>ikt', function()
    M.grep_todos_inside_knowledge()
end, { desc = 'grep in Knowledge folder, ignoring hidden files' })

function M.list_buffers()
    require('telescope.builtin').buffers({
        show_all_buffers = true,
        sort_lastused = true,
        previewer = false,
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.8,
            height = 0.8,
            prompt_position = 'top',
            preview_cutoff = 120,
        },
    })
end

vim.keymap.set('n', '<leader>bb', function()
    M.list_buffers()
end, { desc = 'list buffers' })

function M.browse_mappings()
    require('telescope.builtin').keymaps({
        layout_strategy = 'horizontal',
        prompt_prefix = 'Mappings: ',
        layout_config = {
            width = 0.8,
            height = 0.8,
            prompt_position = 'top',
            preview_cutoff = 120,
        },
    })
end

vim.keymap.set('n', '<leader>bm', function()
    M.browse_mappings()
end, { desc = 'Browse Mappings' })

function M.browse_mappings_with_leader()
    require('telescope.builtin').keymaps({
        default_text = '<Space>',
        prompt_prefix = 'Mappings: ',
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.9,
            height = 0.9,
            prompt_position = 'top',
            preview_cutoff = 120,
        },
        search = '<Space>',
    })
end

vim.keymap.set('n', '<leader>bm', function()
    M.browse_mappings_with_leader()
end, { desc = 'Browse mappings with <leader>' })

function M.browse_mappings_strats_with_char(char)
    require('telescope.builtin').keymaps({
        default_text = char,
        prompt_prefix = 'Mappings: ',
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.9,
            height = 0.9,
            prompt_position = 'top',
            preview_cutoff = 120,
        },
        search = char,
        lhs_filter = false,
    })
end

function M.browse_eagle_assets()
    local rood_dir = '~/Macbook Air.library/'
    telescope.extensions.media_files.media_files({
        cwd = rood_dir,
    })
end

function M.grep_notes()
    require('telescope.builtin').live_grep({
        title = 'Notes',
        path_display = { 'smart' },
        search_dirs = { '~/knowledge' },
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
    })
end

vim.keymap.set('n', '<leader>k', function()
    M.grep_notes()
end, { desc = 'grep in Knowledge folder, ignoring hidden files' })

function M.fetch_repos()
    local function enter(prompt_bufnr)
        local entry = require('telescope.actions.state').get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_set_current_dir(entry.value)
        vim.api.nvim_command('edit .')
    end
    telescope.load_extension('repo').list({
        search_dirs = {
            '~',
        },
        fd_opts = {
            '--hidden', -- Include hidden files and directories
            -- "--case-sensitive", -- Perform a case-sensitive search
            '--absolute-path', -- Return absolute file paths
            '--max-depth',
            '2', -- Limit the search to one directory level
            '--type',
            'd', -- Search only for directories
        },
        layout_config = {
            width = 0.9,
            height = 0.9,
            prompt_position = 'top',
            preview_cutoff = 120,
            preview_width = 0.65,
        },
        attach_mappings = function()
            actions.select_default:replace(enter)
            return true
        end,
    })
end

---Open a file path from typing
---@description Opens a file path from typing
---@usage :lua require('plugins.telescope.custom_pickers').open_path()
function M.open_path()
    require('telescope.builtin').find_files(themes.get_dropdown({
        cwd = '~',
        hidden = true,
        follow = true,
        search_dirs = { '~' },
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            prompt_position = 'top',
        },
    }))
end

---If current buffer is a .md file, list inlinks to the current file in the knowledge base
---We will use filename as the title of the note
---@description Lists inlinks to the current file in the knowledge base
---@usage :lua require('plugins.telescope.custom_pickers').list_inlinks()
function M.list_inlinks()
    local current_file_name = vim.fn.expand('%:t:r') -- => 2021-01-01
    local current_file_extension = vim.fn.expand('%:e') -- => md
    if current_file_extension ~= 'md' then
        print('Not a markdown file')
        return
    end
    local knowledge_base = '~/Knowledge'
    -- Find all files in the knowledge base with 'current_file_name]]'
    local search_pattern = current_file_name .. '%]%]'
    -- Check if anyresults are found, if not then return
    local results = vim.fn.systemlist(
        'rg --files-with-matches ' .. search_pattern .. ' ' .. knowledge_base
    )
    if #results == 0 then
        print('No inlinks found')
        return
    end
    -- If results are found, then open the results in telescope
    require('telescope.builtin').find_files({
        prompt_title = 'Inlinks',
        cwd = knowledge_base,
        search_dirs = { knowledge_base },
        find_command = {
            'rg',
            '--files-with-matches',
            search_pattern,
            knowledge_base,
        },
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            prompt_position = 'top',
        },
    })
end

-- Mappings

local chars = {
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '!',
    '@',
    '#',
    '$',
    '%',
    '^',
    '&',
    '*',
    '(',
    ')',
    '-',
    '_',
    '=',
    '+',
    '[',
    ']',
    '{',
    '}',
    ';',
    ':',
    '\'',
    '"',
    ',',
    '.',
    '/',
    '?',
    '\\',
    '|',
    '`',
    '~',
}

for _, char in ipairs(chars) do
    -- filter mappings with char to left only the ones that exists in neovim keymap
    local keymap = vim.api.nvim_get_keymap('n')
    local filtered_keymap = {}
    for _, key in ipairs(keymap) do
        if key.lhs:sub(1, 1) == char then
            table.insert(filtered_keymap, key)
        end
    end
    for _, key in ipairs(filtered_keymap) do
        if key.lhs:sub(1, 1) == char then
            vim.keymap.set('n', '<leader>bm' .. char, function()
                M.browse_mappings_with_char(char)
            end, {
                desc = 'Browse mappings with ' .. char,
            })
        end
    end
end

--- Commands

vim.api.nvim_create_user_command('GrepNotesWithoutTags', function()
    require('plugins.telescope.custom_pickers').grep_notes_without_tags()
end, {
    nargs = '*',
    complete = 'customlist,v:lua._telescope.builtin_commands',
})

vim.api.nvim_create_user_command('GrepNotes', function()
    require('plugins.telescope.custom_pickers').grep_notes()
end, {
    nargs = '*',
    complete = 'customlist,v:lua._telescope.builtin_commands',
})

vim.api.nvim_create_user_command('TelescopeBrowseFilesInProject', function()
    require('plugins.telescope.custom_pickers').browse_files_in_project()
end, {
    nargs = '*',
    complete = 'customlist,v:lua._telescope.builtin_commands',
})

vim.api.nvim_create_user_command('FetchListOfRepos', function()
    require('plugins.telescope.pickers').fetch_list_of_repos()
end, {})

---Search across nvim plugins data directory
function M.nvim_plugins()
    local XDG_DATA_HOME = vim.env.XDG_DATA_HOME
    local nvim_data = XDG_DATA_HOME .. '/nvim'
    require('telescope.builtin').live_grep({
        prompt_title = 'Searching Inside nvim data',
        search_dirs = { nvim_data },
        hidden = false,
        create_layout = layouts.live_grep,
        entry_maker = entry_makers.gen_from_live_grep,
        path_display = { 'smart' },
    })
end

vim.api.nvim_create_user_command('NvimPlugins', function()
    M.nvim_plugins()
end, {
    nargs = '*',
    complete = 'customlist,v:lua._telescope.builtin_commands',
})

vim.keymap.set('n', '<leader>np', function()
    M.nvim_plugins()
end, { desc = 'grep in project' })

desc = 'Git status'
vim.keymap.set('n', '<leader>gs', function()
    require('telescope.builtin').git_status()
end, { desc = desc })

desc = 'Git branches'
desc = 'Resume search'
vim.keymap.set('n', '<leader>gb', function()
    require('telescope.builtin').git_branches()
end, { desc = desc })

local function document_symbols_for_selected(prompt_bufnr)
    local action_state = require('telescope.actions.state')
    local entry = action_state.get_selected_entry()

    if entry == nil then
        print('No file selected')
        return
    end

    actions.close(prompt_bufnr)

    vim.schedule(function()
        local bufnr = vim.fn.bufadd(entry.path)
        vim.fn.bufload(bufnr)

        local params =
            { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

        vim.lsp.buf_request(
            bufnr,
            'textDocument/documentSymbol',
            params,
            function(err, result, _, _)
                if err then
                    print(
                        'Error getting document symbols: ' .. vim.inspect(err)
                    )
                    return
                end

                if not result or vim.tbl_isempty(result) then
                    print('No symbols found')
                    return
                end

                local function flatten_symbols(symbols, parent_name)
                    local flattened = {}
                    for _, symbol in ipairs(symbols) do
                        local name = symbol.name
                        if parent_name then
                            name = parent_name .. '.' .. name
                        end
                        table.insert(flattened, {
                            name = name,
                            kind = symbol.kind,
                            range = symbol.range,
                            selectionRange = symbol.selectionRange,
                        })
                        if symbol.children then
                            local children =
                                flatten_symbols(symbol.children, name)
                            for _, child in ipairs(children) do
                                table.insert(flattened, child)
                            end
                        end
                    end
                    return flattened
                end

                local flat_symbols = flatten_symbols(result)

                -- Define highlight group for symbol kind
                vim.cmd([[highlight TelescopeSymbolKind guifg=#61AFEF]])

                require('telescope.pickers')
                    .new({}, {
                        prompt_title = 'Document Symbols: '
                            .. vim.fn.fnamemodify(entry.path, ':t'),
                        finder = require('telescope.finders').new_table({
                            results = flat_symbols,
                            entry_maker = function(symbol)
                                local kind = vim.lsp.protocol.SymbolKind[symbol.kind]
                                    or 'Other'
                                return {
                                    value = symbol,
                                    display = function(entry)
                                        local display_text = string.format(
                                            '%-50s %s',
                                            entry.value.name,
                                            kind
                                        )
                                        return display_text,
                                            {
                                                {
                                                    {
                                                        #entry.value.name + 1,
                                                        #display_text,
                                                    },
                                                    'TelescopeSymbolKind',
                                                },
                                            }
                                    end,
                                    ordinal = symbol.name,
                                    filename = entry.path,
                                    lnum = symbol.selectionRange.start.line + 1,
                                    col = symbol.selectionRange.start.character
                                        + 1,
                                }
                            end,
                        }),
                        sorter = require('telescope.config').values.generic_sorter({}),
                        previewer = require('telescope.config').values.qflist_previewer({}),
                        attach_mappings = function(_, map)
                            map('i', '<CR>', function(prompt_bufnr)
                                local selection =
                                    action_state.get_selected_entry()
                                actions.close(prompt_bufnr)
                                vim.cmd('edit ' .. selection.filename)
                                vim.api.nvim_win_set_cursor(
                                    0,
                                    { selection.lnum, selection.col - 1 }
                                )
                            end)
                            return true
                        end,
                    })
                    :find()
            end
        )
    end)
end

desc = 'Document symbols for selected file'
vim.keymap.set(
    'n',
    '<leader>ds',
    document_symbols_for_selected,
    { desc = desc }
)

return M
