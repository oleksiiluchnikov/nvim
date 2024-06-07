local gradient = require("gradient")
local catppuccin = require("catppuccin")
local latte = require("catppuccin.palettes").get_palette("latte")

local black = "#000000"
-- local raw_blue = '#5ba2b0'
local red = "#e1291f"
local pink = "#e24da1"
local blue = gradient.from_stops(4, "#5ba2c2", "#b9b952")[2]
local peach = "#e04d24"
local maroon = "#BD6F3E"
local yellow = "#f0a44b"
local green = "#a9983e"
local sky = "#fbe9e2"
local sapphire = "#89B482"
local mauve = "#91933f"
local lavender = "#c28d3b"
local text = "#b99d8a"
local subtext1 = "#BDAE8B"
local subtext0 = "#A69372"
local overlay2 = "#8C7A58"
local overlay1 = "#735F3F"
local overlay0 = "#958272"
local surface2 = "#4B4F51"
local surface1 = "#2A2D2E"
local surface0 = "#232728"
local light_blue = "#4087f5"
local base = gradient.from_stops(32, "#030300", light_blue)[2]
local mantle = "#191C1D"
local crust = "#151819"
local emerald = "#a4d97c"

-- Highlighting
local bg_diagnostic_unnecessary = overlay1
-- Comment
local fg_comment = gradient.from_stops(10, black, text)[5]
local fg_comment_documentation = gradient.from_stops(6, fg_comment, green)[3]

-- Conditional
local fg_conditional = gradient.from_stops(8, yellow, red)[3]
local fg_diagnostic_unnecessary = gradient.from_stops(8, text, surface0)[6]
local fg_number = gradient.from_stops(8, yellow, pink)[7]
local fg_parameter = gradient.from_stops(6, red, fg_comment)[3]
local fg_typmod_keyword_documentation = gradient.from_stops(9, sky, peach)[8]
fg_typmod_keyword_documentation = gradient.from_stops(8, fg_typmod_keyword_documentation, black)[5]
local fg_type_type_lua = gradient.from_stops(10, yellow, black)[6]

-- Function
local Function = gradient.from_stops(16, yellow, light_blue)
local fg_function_call = Function[12]
local fg_function_builin = gradient.from_stops(6, Function[12], pink)[5]
-- local fg_keyword_function = '#a93e57'

local fg_boolean = fg_number

local fg_property = lavender
local fg_variable_builtin = gradient.from_stops(5, fg_function_builin, fg_property)[2]

local fg_preproc = gradient.from_stops(8, red, "#FFFFFF")[4]
-- local fg_rainbowcol3 = gradient.from_stops(8, red, yellow)[4]
-- dynamicly assign colors
-- local fg_rainbowcolor = "fg_rainbowcol" .. reneat % 8
local function attach_rainbow_colors()
    local colors = gradient.from_stops(8, sky, pink)
    if not colors then
        for i = 1, 8 do
            local rainbowcol = "rainbowcol" .. i
            -- vim.cmd('hi ' .. rainbowcol .. ' guifg=' .. colors[i])
            local ns = vim.api.nvim_get_namespaces()
            print(vim.inspect(ns))
            vim.api.nvim_set_hl(0, rainbowcol, { fg = colors[i] })
        end
    end
end

local fg_repeat = gradient.from_stops(8, fg_conditional, fg_number)[6]
local fg_keyword_operator = gradient.from_stops(8, fg_conditional, red)[6]

local fg_macro = gradient.from_stops(8, mauve, pink)[6]

local fg_character = gradient.from_stops(8, pink, "#FFFFFF")[5]

local fg_copilot_annotation = gradient.from_stops(8, fg_comment, mauve)[5]

-- attach_rainbow_colors()

---@type { [string]: vim.api.keyset.highlight }
local hl = {}

hl.Boolean = { fg = fg_boolean }
hl.Character = { fg = fg_character }
hl.Comment = { fg = fg_comment }
hl.Conditional = { fg = fg_conditional }
hl["@lsp.typemod.keyword.controlFlow.rust"] = { fg = fg_conditional }
hl["@keyword.return"] = { fg = fg_conditional }
hl.CopilotAnnotation = { fg = fg_copilot_annotation }
hl.DiagnosticUnnecessary = { fg = fg_diagnostic_unnecessary }
hl.FloatBorder = { fg = lavender }
hl["@function.builtin"] = { fg = fg_function_builin }
hl["@function.call"] = { fg = fg_function_call }
hl["@lsp.type.function.call.c"] = { fg = fg_function_call }
hl.Function = { fg = fg_function_call }
hl.Keyword = { fg = mauve }
hl["@keyword.operator"] = { fg = fg_keyword_operator }
hl["@lsp.type.keyword.lua"] = { fg = fg_typmod_keyword_documentation }
hl.Macro = { fg = fg_macro }
hl.Number = { fg = fg_number }
hl["@parameter"] = { fg = fg_parameter }
hl["@property"] = { fg = fg_property }
hl.Repeat = { fg = fg_repeat }
hl["@lsp.type.type.lua"] = { fg = fg_type_type_lua }
hl["@typmod.keyword.documentation"] = { fg = fg_typmod_keyword_documentation }
hl["@variable.builtin"] = { fg = fg_variable_builtin }
hl["@comment.documentation"] = { fg = fg_comment_documentation }
hl.LspInlayHint = { fg = "#2a5175", bg = "NONE" }
-- vim.cmd("hi IlluminatedWordRead guibg=#263341")
-- vim.cmd("hi IlluminatedWordWrite guibg=" .. latte.flamingo)
-- vim.cmd("hi IlluminatedWordCurWord guifg=#ffe8e8 guibg=" .. latte.flamingo)
hl.IlluminatedWordRead = { bg = "#263341" }
hl.IlluminatedWordWrite = { bg = latte.flamingo }
hl.IlluminatedWordCurWord = { fg = "#ffe8e8", bg = latte.flamingo }
hl.CmpSelection = { bg = "#26336c" }

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
        light = "latte",
        dark = "mocha",
    },
    color_overrides = {
        mocha = {
            -- blue = '#5ba2b0', -- function call
            blue = blue, -- function call
            peach = peach, -- self
            maroon = maroon, -- bools, calls
            red = red,
            yellow = yellow, -- types, structs, classes
            green = green, -- strings
            sky = sky, -- operator, #, +, ==, etc
            sapphire = sapphire,
            mauve = mauve, -- function call
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
        comments = { "italic" },
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

vim.api.nvim_create_user_command("ReloadCatppuccin", function()
    package.loaded["user.plugins.catppuccin"] = nil
    package.loaded["catppuccin"] = nil
    reload_catppuccin()
    -- package.loaded['catppuccin'] = nil
    -- require('user.plugins.catppuccin')
    vim.cmd("source ~/.config/nvim/lua/user/plugins/catppuccin.lua")
    -- vim.cmd(':LspRestart')
    vim.cmd(":colorscheme catppuccin")
end, {
    nargs = 0,
})

vim.cmd("colorscheme catppuccin")
