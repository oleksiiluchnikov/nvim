local M = {}

--- Table with borders for floating windows
M.borders = {
    single = {
        { "┌", "FloatBorder" },
        { "─", "FloatBorder" },
        { "┐", "FloatBorder" },
        { "│", "FloatBorder" },
        { "┘", "FloatBorder" },
        { "─", "FloatBorder" },
        { "└", "FloatBorder" },
        { "│", "FloatBorder" },
    },
    bold = {
        { "┏", "FloatBorder" },
        { "━", "FloatBorder" },
        { "┓", "FloatBorder" },
        { "┃", "FloatBorder" },
        { "┛", "FloatBorder" },
        { "━", "FloatBorder" },
        { "┗", "FloatBorder" },
        { "┃", "FloatBorder" },
    },
    solid = {
        { "▛", "FloatBorder" },
        { "▀", "FloatBorder" },
        { "▜", "FloatBorder" },
        { "▌", "FloatBorder" },
        { "▙", "FloatBorder" },
        { "▀", "FloatBorder" },
        { "▟", "FloatBorder" },
        { "▌", "FloatBorder" },
    },
}
return M
