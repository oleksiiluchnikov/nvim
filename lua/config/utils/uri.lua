-- URI functions
-- ========================================================================= --
require('config.utils').uri = {}

-- Use string.match with pattern
function require('config.utils').uri.is_valid(url)
    return url:match('^https?://.*$') ~= nil
end
--- Percent encode a string
--- ```lua
--- local encoded = require('config.utils').uri.encode('https://oleksii-luchnikov.com')
--- assert(encoded == 'https%3A%2F%2Foleksii-luchnikov.com')
--- ```
--- @param str string
function require('config.utils').uri.encode(str)
    -- return str:gsub('([^%w ])', function(c)
    return string.gsub(str, '([^%w ])', function(c)
        return string.format('%%%02X', string.byte(c))
    end)
end
--- Percent decode a string
--- ```lua
--- local decoded = require('config.utils').uri.decode('https%3A%2F%2Foleksii-luchnikov.com')
--- assert(decoded == 'https://oleksii-luchnikov.com')
--- ```
--- @param str string
function require('config.utils').uri.decode(str)
    return string.gsub(str, '%%(%x%x)', function(hex)
        return string.char(tonumber(hex, 16))
    end)
end

--- Validate if a string is a valid uri
--- TODO: Add more advanced validation
--- ```lua
--- local is_valid = require('config.utils').uri.validate('https://oleksii-luchnikov.com')
--- assert(is_valid)
--- ```
--- @param str string
--- @return boolean
function require('config.utils').uri.validate(str)
    return str:match('^%w+://')
end

-- test url: [Google](https://www.google.com)
function require('config.utils').uri.fetch_title(url)
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
