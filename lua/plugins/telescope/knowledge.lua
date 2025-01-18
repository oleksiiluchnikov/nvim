local KNOWLEDGE_ROOT = os.getenv('HOME') .. '/knowledge'
local search = ''

-- Grep Public Notes
------------------------------------------------------------------------------
local function grep_public_notes()
    require('telescope.builtin').grep_string({
        search_dirs = {
            KNOWLEDGE_ROOT,
        },
        use_regex = true,
        search = '^share: true$',
    })
end

vim.api.nvim_create_user_command('GrepPublicNotes', function()
    grep_public_notes()
end, {
    nargs = '*',
    complete = 'file',
})

vim.keymap.set('n', '<leader>kpn', function()
    grep_public_notes()
end, {
    silent = true,
    noremap = true,
    desc = 'Grep public notes',
})

------------------------------------------------------------------------------

-- search with ripgrep for lines that don't start with a '#\w+'
search = '^tags:: #\\w+'
-- Grep Notes without Tags
local function grep_notes_without_tags()
    require('telescope.builtin').grep_string({
        use_regex = true,
        search = search,
        path_display = { 'shorten' },
        shorten_path = true,
        cwd = KNOWLEDGE_ROOT,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--files-without-match',
        },
    })
end

vim.api.nvim_create_user_command('GrepNotesWithoutTags', function()
    grep_notes_without_tags()
end, {
    nargs = '*',
    complete = 'file',
})

------------------------------------------------------------------------------
-- Grep Notes with certain Tag and without certain Tag

-- FIXME: This is not working as expected
local function grep_notes_with_tag_without_tag(tag, without_tag)
    local regex = '#' .. tag
    local without_regex = '#' .. without_tag
    search = regex .. '.*' .. without_regex
    require('telescope.builtin').grep_string({
        use_regex = true,
        search = search,
        path_display = { 'shorten' },
        shorten_path = true,
        cwd = KNOWLEDGE_ROOT,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--files-without-match',
            '--files-with-matches',
            '--ignore-case',
            '--invert-match',
        },
    })
end

vim.api.nvim_create_user_command(
    'GrepNotesWithTagWithoutTag',
    function(tag, without_tag)
        grep_notes_with_tag_without_tag(tag, without_tag)
    end,
    {
        nargs = '*',
        complete = 'file',
    }
)

------------------------------------------------------------------------------

search = '\\[\\[.*\\]\\]' -- search for [[...]]

-- Grep Notes without Wiki Links
local function grep_notes_without_wiki_links()
    require('telescope.builtin').grep_string({
        use_regex = true,
        search = search,
        path_display = { 'shorten' },
        shorten_path = true,
        cwd = KNOWLEDGE_ROOT,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--files-without-match',
        },
    })
end

vim.api.nvim_create_user_command('GrepNotesWithoutWikiLinks', function()
    grep_notes_without_wiki_links()
end, {
    nargs = '*',
    complete = 'file',
})

vim.keymap.set('n', '<leader>knwl', function()
    grep_notes_without_wiki_links()
end, {
    silent = true,
    noremap = true,
    desc = 'Grep notes without wiki links',
})

------------------------------------------------------------------------------

-- Grep Notes with certain Tag
local function grep_notes_with_tag(tag)
    local regex = '#' .. tag
    require('telescope.builtin').grep_string({
        use_regex = true,
        search = regex,
        path_display = { 'shorten' },
        shorten_path = true,
        cwd = KNOWLEDGE_ROOT,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--files-without-match',
            '--files-with-matches',
            '--ignore-case',
        },
    })
end

vim.api.nvim_create_user_command('GrepNotesWithTag', function(tag)
    grep_notes_with_tag(tag)
end, {
    nargs = '*',
    complete = 'file',
})

vim.keymap.set('n', '<leader>kp', function()
    grep_notes_with_tag('Project')
end, {
    silent = true,
    noremap = true,
    desc = 'Grep notes with tag',
})

------------------------------------------------------------------------------

-- Grep Notes with tags
local function grep_notes_with_tags(tags)
    local regex = ''
    for _, tag in ipairs(tags) do
        regex = regex .. '#' .. tag .. '(\\s|/).*' -- #tag1.*#tag2.*
    end
    require('telescope.builtin').grep_string({
        prompt_title = 'Grep Notes with Tags',
        use_regex = true,
        search = regex,
        path_display = { 'shorten' },
        shorten_path = true,
        cwd = KNOWLEDGE_ROOT,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--files-without-match',
            '--files-with-matches',
            '--ignore-case',
        },
    })
end

vim.api.nvim_create_user_command('GrepNotesWithTags', function(tags)
    grep_notes_with_tags(tags)
end, {
    nargs = '*',
    complete = 'file',
})

-----------------------------------------------------------------------------

-- Grep Notes with Tags included and Tags excluded tables
local included_tags = { 'Project', 'Status' }
local excluded_tags = { 'Done', 'Deprecated' }

-- FIXME: This is not working as expected
local function grep_notes_with_tags_included_and_excluded(
    included_tags,
    excluded_tags
)
    local regex = ''
    -- for _, tag in ipairs(included_tags) do
    --     regex = regex .. '#' .. tag .. '(\\s|/).*' -- #tag1.*#tag2.*
    -- end
    for _, tag in ipairs(excluded_tags) do
        regex = regex .. '.*#' .. tag .. '(\\s|/).*' -- #tag1.*#tag2.*
    end
    require('telescope.builtin').live_grep({
        prompt_title = 'Grep Notes with included and excluded Tags',
        default_text = regex,
        use_regex = true,
        search = regex,
        find_command = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--files-without-match',
            '--files-with-matches',
            '--ignore-case',
        },
        path_display = { 'smart' },
        cwd = KNOWLEDGE_ROOT,
    })
end
