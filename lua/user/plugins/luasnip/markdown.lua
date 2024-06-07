local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt

local s = luasnip.snippet
local i = luasnip.i

luasnip.add_snippets('markdown', {
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
})
