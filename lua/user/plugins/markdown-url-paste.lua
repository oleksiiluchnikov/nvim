-- test url: [Google](https://www.google.com)
local function fetch_url_title(url)
    -- Bail early if the url obviously isn't a URL.
    if not string.match(url, "^https?://") then
        return ""
    end

    -- Use os.execute to get link's page title.
    local cmd = "curl -sL " .. vim.fn.shellescape(url) .. " 2>/dev/null"
    local handle = io.popen(cmd)
    if not handle then
        return
    end
    local html = handle:read("*a")
    handle:close()
    local pattern = "<title>(.-)</title>"
    local m = string.match(html, pattern)
    if m then
        return m
    end
end

local function put_markdown_link()
    vim.cmd("normal! yiW")
    local url = tostring(vim.fn.getreg("")) or ""
    if url == "" then
        vim.notify("No URL found under the cursor")
        return
    elseif not string.match(url, "^https?://") then
        vim.notify(url .. " doesn't look like a URL")
        return
    end

    -- Fetch the title of the URL.
    local title = fetch_url_title(url)
    if title ~= "" then
        local link = string.format("[%s](%s)", title, url)
        vim.fn.setreg("", link)
        vim.cmd("normal! viWp")
    else
        print("Title not found for link")
    end
end

vim.api.nvim_create_user_command("PutMarkdownLink", put_markdown_link, {
    nargs = 0,
})

-- Make a keybinding (mnemonic: "mark down paste")
vim.keymap.set("n", "<leader>mdp", put_markdown_link, { silent = true, noremap = true })
