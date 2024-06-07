-- Commands
local build_commands = {
    c = "g++ -std=c++17 -o %:p:r.o %",
    cpp = "g++ -std=c++17 -o %:p:r.o %",
    rust = "cargo build --release",
    go = "go build -o %:p:r.o %",
}

local qmk_build_command = "qmk compile -kb idobao/id75/v2 -km oleksiiluchnikov"

local debug_build_commands = {
    c = "g++ -std=c++17 -g -o %:p:r.o %",
    cpp = "g++ -std=c++17 -g -o %:p:r.o %",
    rust = "cargo build",
    go = "go build -o %:p:r.o %",
}

local run_commands = {
    c = "%:p:r.o",
    cpp = "%:p:r.o",
    rust = "cargo run --release",
    go = "%:p:r.o",
    py = "python3 %",
    sh = "zsh %",
    js = "node %",
    applescript = "osascript \"%\"",
}

local function execute_osascript(script)
    local command = string.format("osascript -e '%s'", script)
    vim.cmd(string.format("!%s", command))
end

-- Assign commands

-- "Build" to build current file
vim.api.nvim_create_user_command("Build", function()
    local filetype = vim.bo.filetype
    for file, command in pairs(build_commands) do
        -- if parent dir of current file contains "qmk_firmware" then use qmk build command
        if string.find(vim.fn.expand("%:p:h"), "qmk_firmware") then
            vim.cmd("!" .. qmk_build_command)
            break
        end
        if filetype == file then
            vim.cmd("!" .. command)
            break
        end
    end
end, {})

-- "DebugBuild" to build current file with debug symbols
vim.api.nvim_create_user_command("DebugBuild", function()
    local filetype = vim.bo.filetype
    for file, command in pairs(debug_build_commands) do
        if filetype == file then
            vim.cmd("!" .. command)
            break
        end
    end
end, {})

-- "Run" to run current file
vim.api.nvim_create_user_command("Run", function()
    local filetype = vim.bo.filetype
    for file, command in pairs(run_commands) do
        if filetype == file then
            command = string.gsub(command, "%%", vim.fn.expand("%")) -- replace % with current file path
            vim.notify(vim.fn.system(command))
            break
        end
    end
end, {})

-- "Run" to run jsx script in photoshop
vim.api.nvim_create_user_command("RunPhotoshop", function()
    -- local cmd = "!osascript -e 'tell application \"Adobe Photoshop 2023\"  to do javascript of file \"%s\"'"
    -- local script = vim.fn.readfile(vim.fn.expand("%:p"))
    -- script = table.concat(script, "\\n")
    -- script = string.gsub(script, "'", "\\'")
    -- -- Escape for double quotes
    -- script = string.gsub(script, '"', '\\"')
    -- cmd = string.format(cmd, script)
    -- -- Run command silent
    -- vim.cmd(cmd)
    local cmd =
        "silent exec '!osascript -e \"tell application \\\"Adobe Photoshop 2023\\\"  to do javascript of file \\\"%s\\\"\"'"
    cmd = string.format(cmd, vim.fn.expand("%:p"))
    vim.cmd(cmd)
end, {})

-- "RunPhotoshopScript" to run current file in Photoshop
vim.api.nvim_create_user_command("RunPsScript", function()
    local photoshop_name = vim.fn.system("hs -c 'apps.photoshop.name'")
    -- execute_osascript('\'tell application ' .. photoshop_name .. 'to do javascript of file "%"\'')
    vim.fn.system(
        "osascript -e 'tell application " .. photoshop_name .. " to do javascript of file \"%\"'"
    )
end, {
    nargs = 1,
    complete = function()
        local app_scripts_dir = vim.fn.system("hs -c 'apps.photoshop.paths.scripts'")
        -- Reursively find all files in app_scripts_dir
        -- mdfind -onlyin app_scripts_dir "kMDItemFSName == '*.*' && kMDItemKind != 'Folder'"
        local paths = vim.fn.system("find " .. app_scripts_dir)
        -- Split files by newlines
        local paths_table = vim.split(paths, "\n")
        -- Remove directories
        local files = {}
        for _, path in pairs(paths_table) do
            if vim.fn.isdirectory(path) == 0 then
                -- Remove app_scripts_dir from start of path
                local file = string.sub(path, string.len(app_scripts_dir) + 1)
                if file ~= "" then
                    -- Remove app_scripts_dir from path
                    table.insert(files, file)
                end
            end
        end
        return files
    end,
})

-- "UUID" to generate UUID and put in to register
vim.api.nvim_create_user_command("UUID", function()
    local uuid = vim.fn.system("uuidgen")
    uuid = uuid:gsub("-", ""):lower():gsub("%z", ""):gsub("\n", "")
    vim.api.nvim_put({ uuid }, "c", true, true)
end, {})

-- "BuildAndRun" to build and run current file
vim.api.nvim_create_user_command("BuildAndRun", function()
    vim.cmd([[Build]])
    vim.cmd([[Run]])
end, {})
