local vault = require("vault")
local pickers = require("vault.pickers")

local search = {}
local opts = {
    root = "~/knowledge", -- The root directory of the vault.
    dirs = {
        inbox = "inbox",
        docs = "_docs",
        templates = "_templates",
        journal = {
            root = "Journal",
            daily = "Journal/Daily",
            weekly = "Journal/Weekly",
            monthly = "Journal/Monthly",
            yearly = "Journal/Yearly",
        },
    },
    ignore = {
        ".git/*",
        ".obsidian/*",
        "_docs/*",
        "_templates/*",
        ".trash/*",
    },
    ext = ".md",
    tags = {
        valid = {
            hex = true, -- Hex is a valid tag.
        },
    },
    search_pattern = {
        tag = "#([A-Za-z0-9/_-]+)[\r|%s|\n|$]",
        wikilink = "%[%[([^\\]]*)%]%]",
        note = {
            type = "class::%s#class/([A-Za-z0-9_-]+)",
        },
    },
    search_tool = "rg", -- The search tool to use. Default: "rg"
    notify = {
        on_write = true,
    },
    popups = {
        fleeting_note = {
            title = {
                text = "Fleeting Note",
                preview = "border", -- "border" | "prompt" | "none"
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
                relative = "editor",
                border = {
                    padding = {
                        top = 0,
                        bottom = 0,
                        left = 0,
                        right = 0,
                    },
                    -- T shape side border: ├
                    style = "rounded",
                },
                buf_options = {
                    modifiable = true,
                    readonly = false,
                    filetype = "markdown",
                    buftype = "nofile",
                    swapfile = false,
                    bufhidden = "wipe",
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
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

local desc = "Search notes"

local keymap_opts = {
    silent = true,
    noremap = true,
    desc = desc,
}

function search.for_notes()
    pickers.notes({})
end
vim.api.nvim_create_user_command("VaultSearchNotes", function(args)
    args = args or {}
    search.for_notes()
end, {
    nargs = "*",
    complete = "customlist,v:lua.vault#complete",
    desc = desc,
})

vim.keymap.set("n", "<leader>nn", function()
    pickers.notes()
end, keymap_opts)

keymap_opts.desc = "Search tags"
function search.for_tags()
    pickers.tags()
end
vim.keymap.set("n", "<leader>nt", function()
    pickers.tags()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type`"
function search.notes_with_type()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = true,
    })
end
vim.keymap.set("n", "<leader>ncc", function()
    search.notes_with_type()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Zettel`"
function search.notes_with_zettel()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Zettel" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = true,
    })
end
vim.keymap.set("n", "<leader>ncz", function()
    search.notes_with_zettel()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Project`"
function search.notes_with_project()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Project" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncp", function()
    search.notes_with_project()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Task`"
function search.notes_with_task()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Task" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nct", function()
    search.notes_with_task()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Event`"
function search.notes_with_event()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Event" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nce", function()
    search.notes_with_event()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Workflow`"
function search.notes_with_workflow()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Workflow" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncw", function()
    search.notes_with_workflow()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Person`"
function search.notes_with_person()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Person" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncu", function()
    search.notes_with_person()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Action`"
function search.notes_with_action()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Action" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncx", function()
    search.notes_with_action()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Location`"
function search.notes_with_location()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Location" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncl", function()
    search.notes_with_location()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Meta`"
function search.notes_with_meta_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Meta" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncm", function()
    search.notes_with_meta_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Snippet`"
function search.notes_with_snippet_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Snippet" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncs", function()
    search.notes_with_snippet_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Value`"
function search.notes_with_value_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Value" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncv", function()
    search.notes_with_value_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Aspiration`"
function search.notes_with_aspiriation_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Aspiration" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nca", function()
    search.notes_with_aspiriation_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Path`"
function search.notes_with_path_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Path" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncy", function()
    search.notes_with_path_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Idea`"
function search.notes_with_idea_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Idea" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nci", function()
    search.notes_with_idea_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Goal`"
function search.notes_with_goal_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Goal" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncg", function()
    search.notes_with_goal_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Hardware`"
function search.notes_with_hardware_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Hardware" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nch", function()
    search.notes_with_hardware_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Journal`"
function search.notes_with_journal_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Journal" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>njj", function()
    search.notes_with_journal_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Journal/Daily`"
function search.notes_with_daily_journal_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Journal/Daily" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>njdd", function()
    search.notes_with_daily_journal_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Journal/Weekly`"
function search.notes_with_weekly_journal_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Journal/Weekly" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>njw", function()
    search.notes_with_weekly_journal_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Journal/Monthly`"
function search.notes_with_monthly_journal_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Journal/Monthly" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>njm", function()
    search.notes_with_monthly_journal_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `type/Journal/Yearly`"
function search.notes_with_yearly_journal_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Journal/Yearly" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>njy", function()
    search.notes_with_yearly_journal_tag()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status`"
function search.notes_with_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nss", function()
    search.notes_with_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/TODO`"
function search.notes_with_todo_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/TODO" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nst", function()
    search.notes_with_todo_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/IN-PROGRESS`"
function search.notes_with_in_progress_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/IN-PROGRESS" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nsi", function()
    search.notes_with_in_progress_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/DONE`"
function search.notes_with_done_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/DONE" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nsd", function()
    search.notes_with_done_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/IN-REVIEW`"
function search.notes_with_in_review_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/IN-REVIEW" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nsr", function()
    search.notes_with_in_review_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/ARCHIVED`"
function search.notes_with_archived_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/ARCHIVED" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nsh", function()
    search.notes_with_archived_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/ON-HOLD`"
function search.notes_with_on_hold_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/ON-HOLD" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nso", function()
    search.notes_with_on_hold_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/DEPRECATED`"
function search.notes_with_deprecated_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/DEPRECATED" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nsp", function()
    search.notes_with_deprecated_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/ACTIVE`"
function search.notes_with_active_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/ACTIVE" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nsa", function()
    search.notes_with_active_status()
end, keymap_opts)

keymap_opts.desc = "Search notes with tag `status/SEEDING`"
function search.notes_with_seeding_status()
    pickers.notes({}, {
        search_term = "tags",
        include = { "status/SEEDING" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>nse", function()
    search.notes_with_seeding_status()
end, keymap_opts)

keymap_opts.desc = "Search dates with tag `type/Software`"
function search.notes_with_software_tag()
    pickers.notes({}, {
        search_term = "tags",
        include = { "type/Software" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = false,
    })
end
vim.keymap.set("n", "<leader>ncw", function()
    search.notes_with_software_tag()
end, keymap_opts)

keymap_opts.desc = "Search dates"
function search.dates()
    pickers.dates()
end
vim.keymap.set("n", "<leader>ndd", function()
    search.dates()
end, keymap_opts)

keymap_opts.desc = "Search notes with today's date"
function search.today_date()
    pickers.dates(os.date("%Y-%m-%d"), os.date("%Y-%m-%d"))
end
vim.keymap.set("n", "<leader>ndt", function()
    search.today_date()
end, keymap_opts)

keymap_opts.desc = "Search notes without type tag"
function search.notes_without_type()
    pickers.notes({}, {
        search_term = "tags",
        exclude = { "type" },
        match_opt = "startswith",
        mode = "all",
        case_sensitive = true,
    })
end
vim.keymap.set("n", "<leader>nwc", function()
    search.notes_without_type()
end, keymap_opts)

return search
