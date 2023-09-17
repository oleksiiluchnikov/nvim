local ls = require 'luasnip'

ls.snippets = {
    all = {
        ls.parser.parse_snippet(
            'all',
            [[
            Hello, ${1:world}!
            ]]
        ),
    },
}
