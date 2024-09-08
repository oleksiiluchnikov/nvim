local vault = require('vault')
local pickers = require('vault.pickers')

local search = {}

--- @type vault.Config.options
local opts = {
    features = {
        commands = true,
        cmp = true,
    },
    root = '~/knowledge', -- The root directory of the vault.
    dirs = {
        inbox = 'inbox',
        docs = '_docs',
        templates = '_templates',
        journal = {
            root = 'Journal',
            daily = 'Journal/Daily',
            weekly = 'Journal/Weekly',
            monthly = 'Journal/Monthly',
            yearly = 'Journal/Yearly',
        },
    },
    ignore = {
        '.git/*',
        '.obsidian/*',
        '_docs/*',
        '_templates/*',
        '.trash/*',
    },
    ext = '.md',
    tags = {
        valid = {
            hex = true, -- Hex is a valid tag.
        },
    },
    search_pattern = {
        tag = '#([A-Za-z0-9/_-]+)[\r|%s|\n|$]',
        wikilink = '%[%[([^\\]]*)%]%]',
        note = {
            type = 'class::%s#class/([A-Za-z0-9_-]+)',
        },
    },
    search_tool = 'rg', -- The search tool to use. Default: "rg"
    notify = {
        on_write = true,
    },
    popups = {
        fleeting_note = {
            title = {
                text = 'Fleeting Note',
                preview = 'border', -- "border" | "prompt" | "none"
            },
            editor = { -- @see :h nui.popup
                position = {
                    row = math.floor(vim.o.lines / 2) - 9,
                    col = math.floor(vim.o.columns / 2) - 40,
                },
                size = {
                    height = 6,
                    width = 80,
                },
                enter = true,
                focusable = true,
                zindex = 60,
                relative = 'editor',
                border = {
                    padding = {
                        top = 0,
                        bottom = 0,
                        left = 0,
                        right = 0,
                    },
                    -- T shape side border: ├
                    style = 'rounded',
                },
                buf_options = {
                    modifiable = true,
                    readonly = false,
                    filetype = 'markdown',
                    buftype = 'nofile',
                    swapfile = false,
                    bufhidden = 'wipe',
                },
                win_options = {
                    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
                },
            },
            prompt = {
                hidden = true,
                size = {
                    height = 0.8,
                    width = 0.8,
                },
            },
            results = {
                size = {
                    height = 10,
                    width = 80,
                },
            },
        },
    },
}

vault.setup(opts)

-- -- VaultNotes: Search for notes in the vault.
-- keymap_opts.desc = 'notes'
-- vim.keymap.set('n', '<leader>ns', function()
--     pickers.notes()
-- end, keymap_opts)
--
-- function search.for_tags()
--     pickers.tags()
-- end
--
-- -- VaultSearchTags: Search for tags in the vault.
-- keymap_opts.desc = 'tags'
-- vim.keymap.set('n', '<leader>nt', function()
--     pickers.tags()
-- end, keymap_opts)
--
-- -- VaultLeaves: Search for notes that do not have any outgoing links.
-- keymap_opts.desc = 'leaves'
-- vim.keymap.set('n', '<leader>nl', function()
--     vim.cmd('VaultLeaves')
-- end, keymap_opts)
--
-- -- VaultOrphans: Search for notes that do not have any links to them.
-- keymap_opts.desc = 'orphans'
-- vim.keymap.set('n', '<leader>no', function()
--     vim.cmd('VaultOrphans')
-- end, keymap_opts)
--
-- -- VaultNoteOutlinks: Search for notes that have outgoing links.
-- keymap_opts.desc = 'outlinks'
-- vim.keymap.set('n', '<leader>nno', function()
--     vim.cmd('VaultNoteOutlinks')
-- end, keymap_opts)
--
-- -- VaultNoteInlinks: Search for notes that have incoming links.
-- keymap_opts.desc = 'inlinks'
-- vim.keymap.set('n', '<leader>nni', function()
--     vim.cmd('VaultNoteInlinks')
-- end, keymap_opts)
--
-- -- VaultRandomNote: Open a random note.
-- keymap_opts.desc = 'random'
-- vim.keymap.set('n', '<leader>nr', function()
--     vim.cmd('VaultRandomNote')
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type`'
-- function search.notes_with_type()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = true,
--     })
-- end
--
-- -- Search notes with tag `type`
-- vim.keymap.set('n', '<leader>ncc', function()
--     search.notes_with_type()
-- end, keymap_opts)
--
-- -- Search notes with tag `type/Zettel`
-- keymap_opts.desc = 'Search notes with tag `type/Zettel`'
-- function search.notes_with_zettel()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Zettel' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = true,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncz', function()
--     search.notes_with_zettel()
-- end, keymap_opts)
--
-- -- Search notes with tag `type/Project`
-- keymap_opts.desc = 'Search notes with tag `type/Project`'
-- function search.notes_with_project()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Project' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncp', function()
--     search.notes_with_project()
-- end, keymap_opts)
--
-- -- Search notes with tag `type/Task`
-- keymap_opts.desc = 'Search notes with tag `type/Task`'
-- function search.notes_with_task()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Task' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>nct', function()
--     search.notes_with_task()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Event`'
-- function search.notes_with_event()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Event' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>nce', function()
--     search.notes_with_event()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Workflow`'
-- function search.notes_with_workflow()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Workflow' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncw', function()
--     search.notes_with_workflow()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Person`'
-- function search.notes_with_person()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Person' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncu', function()
--     search.notes_with_person()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Action`'
-- function search.notes_with_action()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Action' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncx', function()
--     search.notes_with_action()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Location`'
-- function search.notes_with_location()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Location' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncl', function()
--     search.notes_with_location()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Meta`'
-- function search.notes_with_meta_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Meta' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncm', function()
--     search.notes_with_meta_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Snippet`'
-- function search.notes_with_snippet_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Snippet' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncs', function()
--     search.notes_with_snippet_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Value`'
-- function search.notes_with_value_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Value' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncv', function()
--     search.notes_with_value_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Aspiration`'
-- function search.notes_with_aspiriation_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Aspiration' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>nca', function()
--     search.notes_with_aspiriation_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Path`'
-- function search.notes_with_path_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Path' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncy', function()
--     search.notes_with_path_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Idea`'
-- function search.notes_with_idea_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Idea' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>nci', function()
--     search.notes_with_idea_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Goal`'
-- function search.notes_with_goal_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Goal' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>ncg', function()
--     search.notes_with_goal_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Hardware`'
-- function search.notes_with_hardware_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Hardware' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>nch', function()
--     search.notes_with_hardware_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Journal`'
-- function search.notes_with_journal_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Journal' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>njj', function()
--     search.notes_with_journal_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Journal/Daily`'
-- function search.notes_with_daily_journal_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Journal/Daily' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>njdd', function()
--     search.notes_with_daily_journal_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Journal/Weekly`'
-- function search.notes_with_weekly_journal_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Journal/Weekly' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>njw', function()
--     search.notes_with_weekly_journal_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Journal/Monthly`'
-- function search.notes_with_monthly_journal_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Journal/Monthly' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>njm', function()
--     search.notes_with_monthly_journal_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with tag `type/Journal/Yearly`'
-- function search.notes_with_yearly_journal_tag()
--     pickers.notes({}, {
--         search_term = 'tags',
--         include = { 'type/Journal/Yearly' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = false,
--     })
-- end
--
-- vim.keymap.set('n', '<leader>njy', function()
--     search.notes_with_yearly_journal_tag()
-- end, keymap_opts)
--
-- -- keymap_opts.desc = "Search notes with tag `status`"
-- -- function search.notes_with_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nss", function()
-- --     search.notes_with_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/TODO`"
-- -- function search.notes_with_todo_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/TODO" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nst", function()
-- --     search.notes_with_todo_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/IN-PROGRESS`"
-- -- function search.notes_with_in_progress_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/IN-PROGRESS" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nsi", function()
-- --     search.notes_with_in_progress_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/DONE`"
-- -- function search.notes_with_done_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/DONE" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nsd", function()
-- --     search.notes_with_done_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/IN-REVIEW`"
-- -- function search.notes_with_in_review_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/IN-REVIEW" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nsr", function()
-- --     search.notes_with_in_review_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/ARCHIVED`"
-- -- function search.notes_with_archived_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/ARCHIVED" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nsh", function()
-- --     search.notes_with_archived_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/ON-HOLD`"
-- -- function search.notes_with_on_hold_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/ON-HOLD" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nso", function()
-- --     search.notes_with_on_hold_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/DEPRECATED`"
-- -- function search.notes_with_deprecated_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/DEPRECATED" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nsp", function()
-- --     search.notes_with_deprecated_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/ACTIVE`"
-- -- function search.notes_with_active_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/ACTIVE" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nsa", function()
-- --     search.notes_with_active_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search notes with tag `status/SEEDING`"
-- -- function search.notes_with_seeding_status()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "status/SEEDING" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>nse", function()
-- --     search.notes_with_seeding_status()
-- -- end, keymap_opts)
-- --
-- -- keymap_opts.desc = "Search dates with tag `type/Software`"
-- -- function search.notes_with_software_tag()
-- --     pickers.notes({}, {
-- --         search_term = "tags",
-- --         include = { "type/Software" },
-- --         match_opt = "startswith",
-- --         mode = "all",
-- --         case_sensitive = false,
-- --     })
-- -- end
--
-- vim.keymap.set('n', '<leader>ncw', function()
--     search.notes_with_software_tag()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search dates'
-- function search.dates()
--     pickers.dates()
-- end
--
-- vim.keymap.set('n', '<leader>ndd', function()
--     search.dates()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes with today\'s date'
-- function search.today_date()
--     pickers.dates(os.date('%Y-%m-%d'), os.date('%Y-%m-%d'))
-- end
--
-- vim.keymap.set('n', '<leader>ndt', function()
--     search.today_date()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'Search notes without type tag'
-- function search.notes_without_type()
--     pickers.notes({}, {
--         search_term = 'tags',
--         exclude = { 'type' },
--         match_opt = 'startswith',
--         mode = 'all',
--         case_sensitive = true,
--     })
-- end
--
-- keymap_opts.desc = 'without type'
-- vim.keymap.set('n', '<leader>nwc', function()
--     search.notes_without_type()
-- end, keymap_opts)
--
-- keymap_opts.desc = 'properties'
-- vim.keymap.set('n', '<leader>np', function()
--     vim.cmd('VaultProperties')
-- end, keymap_opts)
--

local mappings = {
    {
        '<leader>ns',
        '<cmd>VaultNotes<CR>',
        desc = 't: notes',
        noremap = true,
    },
    {
        '<leader>nt',
        '<cmd>VaultTags<CR>',
        desc = 't: tags',
        noremap = true,
    },
    {
        '<leader>nl',
        '<cmd>VaultLeaves<CR>',
        desc = 't: leaves',
        noremap = true,
    },
    {
        '<leader>no',
        '<cmd>VaultOrphans<CR>',
        desc = 't: orphans',
        noremap = true,
    },
    {
        '<leader>nr',
        '<cmd>VaultRandomNote<CR>',
        desc = 'edit random note',
        noremap = true,
    },
    {
        '<leader>p',
        '<cmd>VaultProperties<CR>',
        desc = 't: properties',
        noremap = true,
    },
}
require('which-key').add(mappings)

local mappings_markdown = {
    {
        '<leader>nno',
        '<cmd>VaultNoteOutlinks<CR>',
        desc = 't: open outlinks',
    },
    {
        '<leader>nni',
        '<cmd>VaultNoteInlinks<CR>',
        desc = 't: open inlinks',
    },
    {
        '<leader>nnd',
        '<cmd>VaultNoteRename<CR>',
        desc = 't: rename note',
    },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(event)
        local function open_note_in_obsidian()
            local note = require('vault.notes.note')(vim.fn.expand('%:p'))
            local vault_name =
                vim.fn.fnamemodify(require('vault.config').options.root, ':t')
            vim.fn.system(
                string.format(
                    'open \'obsidian://open?vault=%s&file=%s\'',
                    vim.u.uri.encode(vault_name),
                    vim.u.uri.encode(note.data.stem)
                )
            )
        end
        table.insert(mappings_markdown, {
            '<leader>nne',
            open_note_in_obsidian,
            desc = 't: rename note',
        })
        require('which-key').add(mappings_markdown)
    end,
})

return search
