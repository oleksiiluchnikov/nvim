local easypick = require("easypick")
local previewers = require("telescope.previewers")
local from_entry = require("telescope.from_entry")
local Path = require("plenary.path")
local utils = require("telescope._extensions.repo.utils")

local function search_markdown_readme(dir)
    for _, name in pairs({
        "README",
        "README.md",
        "README.markdown",
        "README.mkd",
    }) do
    local file = dir / name
    if file:is_file() then
        return file
    end
end
return nil
end

local function search_generic_readme(dir)
    local doc_path = Path:new(dir, "README.*")
    local maybe_doc = vim.split(vim.fn.glob(doc_path.filename), "\n")
    for _, filepath in pairs(maybe_doc) do
        local file = Path:new(filepath)
        if file:is_file() then
            return file
        end
    end
    return nil
end

local function search_doc(dir)
    local doc_path = Path:new(dir, "doc", "**", "*.txt")
    local maybe_doc = vim.split(vim.fn.glob(doc_path.filename), "\n")
    for _, filepath in pairs(maybe_doc) do
        local file = Path:new(filepath)
        if file:is_file() then
            return file
        end
    end
    return nil
end

-- TODO: I want to pass list of tags to this function
local function list_dir_with_tags(tags)
    local cmd = "mdfind \"kMDItemUserTags == '*" .. tags .. "*' && kMDItemContentType == 'public.folder'\""
    local result = vim.fn.systemlist(cmd)
    return result
end

local gen_remote_repos_command = [=[
home_username=$(basename "$HOME")
email="oleksiiluchnikov@gmail.com"  # Adjust this to your email

# Use -d for search depth, adjust as needed
# Combine rg patterns
fd -H -t d -d 10 ".git" | while read -r gitdir; do
    repo_path=$(dirname "$gitdir")
    
    # Ensure that the directory contains a config file
    if [[ -f "$gitdir/config" ]]; then
        if rg -q "(url.*$home_username|$email)" "$gitdir/config"; then
            echo "$repo_path"
        fi
    fi
done
]=]

easypick.setup({
    pickers = {
        {
            name = "remote_repos",
            command = gen_remote_repos_command,
            previewer = previewers.new_termopen_previewer({
                get_command = function(entry)
                    local dir = Path:new(from_entry.path(entry))
                    local doc = search_markdown_readme(dir)
                    if doc then
                        return utils.find_markdown_previewer_for_document(doc.filename)
                    end
                    doc = search_generic_readme(dir)
                    if not doc then
                        doc = search_doc(dir)
                    end
                    if not doc then
                        return { "echo", "" }
                    end
                    return utils.find_generic_previewer_for_document(doc.filename)
                end,
            }),
        },
        {
            name = "my_repos",
            command = "mdfind \"kMDItemUserTags == '*Repository*' && kMDItemContentType == 'public.folder'\"",
            previewer = previewers.new_termopen_previewer({
                get_command = function(entry)
                    local dir = Path:new(from_entry.path(entry))
                    local doc = search_markdown_readme(dir)
                    if doc then
                        return utils.find_markdown_previewer_for_document(doc.filename)
                    end
                    doc = search_generic_readme(dir)
                    if not doc then
                        doc = search_doc(dir)
                    end
                    if not doc then
                        return { "echo", "" }
                    end
                    return utils.find_generic_previewer_for_document(doc.filename)
                end,
            }),}
        }
    })
