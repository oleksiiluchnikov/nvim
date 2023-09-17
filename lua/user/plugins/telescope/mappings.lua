-- local builtin = require('telescope.builtin')
-- local HOME = os.getenv('HOME')

local NORMAL = 'n'
-- local INSERT = 'i'
-- local COMMAND = 'c'
-- local TERMINAL = 't'
local VISUAL = 'v'
-- local VISUAL_BLOCK = 'x'
-- local VISUAL_LINE = 'V'

local M = {}
local Path = require('plenary.path')
-- local utils = require "telescope.utils"

--- Get the current visual selection.
--@return string|nil
local function get_current_visual_selection()
    -- if no selection, return nil
    if vim.fn.mode() ~= 'v' then
        return nil
    end
    local stored_register = vim.fn.getreg('"')
    vim.cmd("normal! y") -- 
    -- local selection = vim.fn.getreg('"')
    -- clear the register
    vim.fn.setreg('"' , stored_register)
end


-- Find project root directory using git/hg/svn/bzr markers.
--@return string|nil
function M.find_project_root()
    local markers = { '.git', '.hg', '.svn', '.bzr' }
    local current_path = vim.fn.expand('%:p:h')
    if current_path == '' then
        return vim.fn.expand('~')
    end
    local path = Path:new(current_path)

    local function has_marker(dir)
        for _, marker in ipairs(markers) do
            if Path:new(dir, marker):exists() then
                return true
            end
        end
        return false
    end

    while path.filename ~= '/' do
        if has_marker(path.filename) then
            return path.filename
        end
        path = path:parent()
    end
    return nil
end


-- ============================================================================
--  Git
-- ============================================================================

local function_str = {
 ["lua"] = "function",
 ["python"] = "def",
 ["rust"] = "fn",
 ["ts"] = "function",
 ["js"] = "function",
 ["svelte"] = "function",
 ["latex"] = "\\section",
 ["c"] = ".+ .+\\(\\) \\{",
 ["cpp"] = ".+ .+\\(\\) \\{",
}

local extensions = {
 ["lua"] = { "lua" },
 ["python"] = { "py" },
    ["typescript"] = { "ts" },
    ["javascript"] = { "js" },
    ["svelte"] = { "svelte" },
 ["rust"] = { "rs" },
 ["c"] = { "c", "h" },
 ["cpp"] = { "cpp", "hpp" },
 ["latex"] = { "tex" },
}


-- Knowledge base
-- ===========================================================================

-- Help tags
-- ===========================================================================

--- Grep help tags from word under cursor
function M.grep_help_tags_from_word_under_cursor()
    local word = vim.fn.expand("<cword>")
    P(word)
    -- require('telescope.builtin').help_tags({
    --     default_text = word,
    -- })
end


vim.keymap.set(NORMAL, '<leader>ff', function() M.find_files() end, {
    desc = 'find files',
    noremap = true,
})
----------------------------------------------------------------------------------------

-- LEADER > gd -- Goto Definition
-- ============================================================================
function M.goto_definition()
    require('telescope.builtin').lsp_definitions({
        prompt_title = "Go to Definition",
    })
end
vim.keymap.set(NORMAL, 'gd', function() M.goto_definition() end, {
    desc = 'go to definition',
    noremap = true,
})
----------------------------------------------------------------------------------------

function M.goto_definition_from_visual_selection()
    local visual_selection = get_current_visual_selection()
    require('telescope.builtin').lsp_definitions({
        prompt_title = "Go to Definition",
        default_text = visual_selection,
    })
end

vim.keymap.set(VISUAL, 'gdv', function() M.goto_definition_from_visual_selection() end, {
    desc = 'go to definition from visual selection',
    noremap = true,
})
----------------------------------------------------------------------------------------

function M.goto_definition_with_vertical_split()
    vim.cmd("vsplit")
    M.goto_definition()
end

vim.keymap.set(NORMAL, '<leader>gdv', function() M.goto_definition_with_vertical_split() end, {
    desc = 'go to definition with vertical split',
    noremap = true,
})
----------------------------------------------------------------------------------------
function M.goto_definition_with_horizontal_split()
    vim.cmd("split")
    M.goto_definition()
end

vim.keymap.set(NORMAL, '<leader>gds', function() M.goto_definition_with_horizontal_split() end, {
    desc = 'go to definition with horizontal split',
    noremap = true,
})
----------------------------------------------------------------------------------------

-- [leader] >  g(lobal) -- Search for Git

-- List repositories using the Telescope repo extension.
function M.list_repos()
    local opts = {
        find_command = {
            "fd",
            "--hidden",
            "--follow",
        },
    }

    opts.title = "Repositories"
    require("telescope").extensions.repo.list(opts)
end

vim.keymap.set(NORMAL, '<leader>gr', function() M.list_repos() end, {
    desc = 'List all git repositories in home',
    noremap = true,
})
----------------------------------------------------------------------------------------

-- LEADER > h -- Help
-- ============================================================================
-- [leader] > h(elp_tags) -- Search for help tags

--- Grep help tags
function M.grep_help_tags()
    require('telescope.builtin').help_tags({})
end

vim.keymap.set(NORMAL, '<leader>h', function() M.grep_help_tags() end, {
    desc = 'search for help tags',
    noremap = true,
    silent = false,
})
----------------------------------------------------------------------------------------

--- Grep help tags from visual selection
function M.grep_help_tags_from_visual_selection()
    local current_selection = get_current_visual_selection()
    LOG(current_selection)
    require('telescope.builtin').help_tags({
        default_text = current_selection,
    })
end

vim.keymap.set(VISUAL, '<leader>h', function() M.grep_help_tags_from_visual_selection() end, {
    desc = 'search for help tags from visual selection',
    noremap = true,
})
----------------------------------------------------------------------------------------

-- ============================================================================
-- LEADER > k -- Knowledge
-- ============================================================================

--- Find files in Knowledge base
function M.find_files_in_knowledge_base()
    require('telescope.builtin').find_files({
        prompt_title = "Find Files in Knowledge Base",
        cwd = "~/Knowledge",
    })
end

vim.keymap.set(NORMAL, '<leader>k', function() M.find_files_in_knowledge_base() end, {
    desc = 'grep in Knowledge folder, ignoring hidden files',
    noremap = true,
})
----------------------------------------------------------------------------------------

-- ============================================================================
-- LEADER > e -- Explorer
-- ============================================================================

-- Browse files using the file_browser extension.
function M.browse_files()
    require("telescope").extensions.file_browser.file_browser {
        title = "Browse Files",
        path_display = { "smart" },
        cwd = "~",
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.65, width = 0.75 },
        hidden = true,                             -- Show hidden files
        dir_icon = "▪",                          -- Set the directory icon
        dir_icon_hl = "TelescopeFileBrowserDirIcon", -- Set the directory icon highlight group
        grouped = true,                            -- Group files by extension
    }
end

-- [leader] > e(xplorer) > h(ome) -- blazing fast file browser in whole home
vim.keymap.set(NORMAL, '<leader>eh', function() M.browse_files() end, {
    desc = 'Blazing fast file browser in whole home'
})
----------------------------------------------------------------------------------------

function M.browse_files_in_project()
    local root_dir = M.find_project_root()
    if root_dir == nil then
        print("No project root found")
        return
    end
    require("telescope").extensions.file_browser.file_browser {
        title = "Browse Files",
        path_display = { "smart" },
        cwd = root_dir,
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.65, width = 0.75 },
        hidden = true,                             -- Show hidden files
        dir_icon = "▪",                          -- Set the directory icon
        dir_icon_hl = "TelescopeFileBrowserDirIcon", -- Set the directory icon highlight group
        grouped = true,                            -- Group files by extension
    }
end

vim.api.nvim_create_user_command(
    "TelescopeBrowseFilesInProject",
    function() M.browse_files_in_project() end,
    { nargs = 0 }
)

-- [leader] > e(xplorer) > p(roject) -- blazing fast file browser in current project
vim.keymap.set(NORMAL, '<leader>ep', ':TelescopeBrowseFilesInProject<CR>', {
    desc = 'Browse files in current project'
})
----------------------------------------------------------------------------------------

-- ============================================================================
-- LEADER > i -- Inside
-- ============================================================================

--- Greps inside the current project.
function M.grep_inside_project()
    local root_dir = M.find_project_root()
    if root_dir == nil then
        print("No project root found")
        return
    end
    require('telescope.builtin').live_grep({
        prompt_title = "Search Inside Project",
        cwd = root_dir,
        hidden = false,
    })
end

vim.keymap.set(NORMAL, '<leader>ip', function() M.grep_inside_project() end, {
    desc = 'Grep inside current project',
})
----------------------------------------------------------------------------------------

--- Greps inside the current project for a specific function.
--- based on language
function M.grep_functions_inside_project()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    local search = function_str[filetype] .. " "
    local patterns = function()
        local list = {}
        for _, ext in ipairs(extensions[filetype]) do
            list[#list + 1] = "-g*." .. ext .. ""
        end
		return list
    end

    require('telescope.builtin').live_grep({
	  default_text = search,
	  prompt_title = "Find Function in Project",
	  -- additional_args = patterns(),
      search_dirs = { M.find_project_root() },
    })
end

vim.keymap.set(NORMAL, '<leader>ipf', function() M.grep_functions_inside_project() end, {
    desc = 'grep in project'
})
----------------------------------------------------------------------------------------

-- Search for Neovim related TODOs using grep_string.
function M.grep_todos_inside_project()
    require("telescope.builtin").live_grep {
        title = "TODOs",
        prompt_prefix = "TODO: ",
        path_display = { "smart" },
        search = "TODO",
        cwd = M.find_project_root(),
    }
end

vim.keymap.set(NORMAL, '<leader>iptd', function() M.grep_todos_inside_project() end, {
    desc = 'grep in project'
})
----------------------------------------------------------------------------------------

function M.grep_inside_knowledge()
    require('telescope.builtin').live_grep({
        prompt_title = "Searching Inside Knowledge Base",
        search_dirs = { "~/Knowledge" },
        hidden = false,
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.8,
            height = 0.8,
            prompt_position = 'top',
            preview_cutoff = 120,
        },
        path_display = { "smart" },
    })
end

-- [leader] > i(nside) > k(nowledge) -- search by content in ~/Knowledge
vim.keymap.set(NORMAL, '<leader>ik', function() M.grep_inside_knowledge() end, {
    desc = 'grep in Knowledge folder, ignoring hidden files'
})

----------------------------------------------------------------------------------------
function M.grep_todos_inside_knowledge()
    require("telescope.builtin").live_grep {
        title = "TODOs",
        prompt_prefix = "TODO: ",
        path_display = { "smart" },
        search = "- [ ]",
        search_dirs = { "~/Knowledge" },
    }
end

vim.keymap.set(NORMAL, '<leader>ikt', function() M.grep_todos_inside_knowledge() end, {
    desc = 'grep in Knowledge folder, ignoring hidden files'
})

-- ============================================================================
-- -- Buffers
-- ============================================================================

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

vim.keymap.set(NORMAL, '<leader>bb', function() M.list_buffers() end, {
    desc = 'list buffers'
})
----------------------------------------------------------------------------------------

function M.write_then_source()
    vim.cmd("write")
    if vim.bo.filetype == "lua" then
        local dir = M.find_project_root()
        -- if dir has nvim
        if string.find(dir, "nvim") then
            -- reload the file
            vim.cmd("source %")
            return
        end
    end
end


vim.keymap.set(NORMAL, '<leader>xx', function() M.write_then_source() end, {
    desc = 'write and source current file',
    noremap = true
})
----------------------------------------------------------------------------------------

-- ============================================================================
-- MAPPINGS
-- ============================================================================

function M.browse_mappings()
    require('telescope.builtin').keymaps({
        layout_strategy = 'horizontal',
        prompt_prefix = "Mappings: ",
        layout_config = {
            width = 0.8,
            height = 0.8,
            prompt_position = 'top',
            preview_cutoff = 120,
        },
    })
end

vim.keymap.set(NORMAL, '<leader>bm', function() M.browse_mappings() end, {
    desc = 'Browse Mappings'
})
----------------------------------------------------------------------------------------

function M.browse_mappings_with_leader()
    require('telescope.builtin').keymaps({
        default_text = '<Space>',
        prompt_prefix = "Mappings: ",
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

vim.keymap.set(NORMAL, '<leader>bm<leader>', function() M.browse_mappings_with_leader() end, {
    desc = 'Browse mappings with <leader>'
})

local chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+',
    '[', ']', '{', '}', ';', ':', "'", '"', ',', '.', '/', '?', '\\', '|',
    '`', '~',
}

function M.browse_mappings_strats_with_char(char)
    require('telescope.builtin').keymaps({
        default_text = char,
        prompt_prefix = "Mappings: ",
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
            vim.keymap.set(NORMAL, '<leader>bm' .. char, function() M.browse_mappings_strats_with_char(char) end, {
                desc = 'Browse mappings with ' .. char
            })
        end
    end
end
----------------------------------------------------------------------------------------

function M.browse_assets()
    local rood_dir = '~/Macbook Air.library/'
    require('telescope').extensions.media_files.media_files({
        cwd = rood_dir,
    })
end

vim.keymap.set(NORMAL, '<leader>ba', function() M.browse_assets() end, {
    desc = 'Browse Assets'
})

vim.o.timeoutlen = 300


----------------------------------------------------------------------------------------

function M.grep_notes_without_tags()
    require("telescope.builtin").live_grep {
        title = "Notes without tags",
        path_display = { "smart" },
        search = "- [ ]",
        search_dirs = { "~/Knowledge" },
    }
end

vim.api.nvim_create_user_command(
    "GrepNotesWithoutTags",
    function()
        M.grep_notes_without_tags()
    end,
    {
        nargs = "*",
        complete = "customlist,v:lua._telescope.builtin_commands",
    }
)

vim.keymap.set(NORMAL, '<leader>in', function() M.grep_notes_without_tags() end, {
    desc = 'grep in Knowledge folder, ignoring hidden files'
})


return M
