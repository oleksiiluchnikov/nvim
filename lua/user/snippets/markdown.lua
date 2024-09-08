local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt
local ft = 'markdown'

local s = luasnip.snippet
local i = luasnip.i
local c = luasnip.choice_node
local t = luasnip.text_node

local function get_title()
    -- find the first line that starts with '#\s' and use that as the title
    local title = ''
    for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        if line:match('^#+%s') then
            title = line
            break
        end
    end
    return title
end

luasnip.add_snippets(ft, {
    s(
        { trig = 'created', dscr = 'Created date' },
        fmt(
            [[
        created: {}
        ]],
            {
                i(1, os.date('%Y-%m-%d %A')),
            }
        )
    ),
    s(
        { trig = 'title', dscr = 'Title' },
        fmt(
            [[
        title: {}
        ]],
            {
                i(1, get_title()),
            }
        )
    ),
    s(
        { trig = 'frontmatter', dscr = 'Document frontmatter' },
        fmt(
            [[
      ---
      tags: {}
      ---

    ]],
            {
                i(1, 'value'),
            }
        )
    ),
    s(
        { trig = 'type', dscr = 'Type' },
        fmt(
            [[
        type: {}
        ]],
            {
                i(1, 'value'),
            }
        )
    ),
    s(
        { trig = 'status', dscr = 'Status' },
        fmt(
            [[
        status: {}
        ]],
            {
                -- i(1, "value"),
                c(1, {
                    t('TODO'),
                    t('IN-PROGRESS'),
                    t('DONE'),
                    t('IN-REVIEW'),
                    t('ARCHIVED'),
                    t('ON-HOLD'),
                    t('DEPRECATED'),
                    t('ACTIVE'),
                }),
            }
        )
    ),
})
