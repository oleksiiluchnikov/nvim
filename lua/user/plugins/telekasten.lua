require('telekasten').setup({
    home = vim.fn.expand("~/Knowledge"),
    daily = vim.fn.expand("~/Knowledge"),
    weekly = vim.fn.expand("~/Knowledge"),
    templates = vim.fn.expand("~/Knowledge"),
    image_subdir = vim.fn.expand("~/Knowledge"),
    extension = ".md",
})
