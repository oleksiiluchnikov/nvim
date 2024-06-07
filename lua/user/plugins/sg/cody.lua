local cody_commands = require("sg.cody.commands")

--- Get the lua version of the current buffer
---
---@return string
local function get_lua_version()
    local buffer_path = tostring(vim.fn.expand("%:p:h"))
    local nvim_path = tostring(vim.fn.stdpath("config"))
    local is_neovim = string.find(buffer_path, nvim_path) and true or false
    local is_hammerspoon = string.find(buffer_path, "hammerspoon") and true
        or false
    if is_neovim then
        return "LuaJIT"
    elseif is_hammerspoon then
        local lua_version = vim.fn.system("hs -c _VERSION"):gsub("[\n\r]", "")
        if lua_version:match("^error") then
            vim.notify(lua_version, vim.log.levels.ERROR, {
                title = "Neovim",
            })
        end
        return lua_version
    end
    return "LuaJIT"
end


-- Get start and end lines for code selection
---@return number, number
local function get_selection_lines()
    -- local start_line = vim.fn.line("'<")
    -- local end_line = vim.fn.line("'>")
    --
    -- if start_line == end_line then
    --     -- Default to current line if no selection
    --     start_line = vim.fn.line(".")
    --     end_line = start_line
    -- end
    --
    -- Better solution is to use `getpos` function
    local _, start_line, _, _, _ = unpack(vim.fn.getpos("'<"))
    local _, end_line, _, _, _ = unpack(vim.fn.getpos("'>"))

    if start_line == end_line then
        -- Default to current line if no selection
        start_line = vim.fn.line(".")
        end_line = start_line
    end


    return start_line, end_line
end

vim.api.nvim_create_user_command("CodyGetSelectionLines", function()
    local start_line, end_line = get_selection_lines()
    print(start_line, end_line)
end, {
    nargs = 0,
    range = true,
})

--- Get the current visual selection formatted for markdown.
--- @return string selection in fenced markdown code block.
local function get_visual_selection_markdown()
    local filetype = vim.bo.filetype
    local bufnr = vim.api.nvim_get_current_buf()
    local start_line, end_line = get_selection_lines()
    local range_text = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
    local selection = table.concat(range_text, "\n")
    local selection_in_fences = string.format("```%s\n%s\n```", filetype, selection)
    return selection_in_fences
end

--- Shorten type error
---@return nil
local function shorten_type_error()
    local instruction = [=[
    Explain this diagnostic for `%s` code in shortest possible way:
    %s
    Remove all unnecesary noise, make it short and sweet.
    ]=]

    vim.diagnostic.goto_prev()
    ---@diagnostic disable-next-line: undefined-field
    local error_msg = vim.diagnostic.get_next().message
    vim.diagnostic.goto_next()

    local filetype = vim.bo.filetype

    if filetype == "lua" then
        filetype = filetype .. " " .. get_lua_version()
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local prompt_instruction = string.format(instruction, vim.bo.filetype, error_msg)

    cody_commands.do_task(
        bufnr,
        0,
        1,
        prompt_instruction .. "\n\n" .. error_msg
    )
end

-- Commands
vim.api.nvim_create_user_command("CodyShortenTypeError", function()
    shorten_type_error()
end, {
    nargs = 0,
})

--- Improve prompt instruction for `Cody`.
--- @param start_line number
--- @param end_line number
--- @returns nil
local function improve_prompt_instruction(start_line, end_line)
    local instruction = [=[
    Please rewrite this prompt instruction to:
    - Clearly state the specific task or goal
    - Provide necessary context, guidelines, and requirements
    - Include concrete examples if helpful
    - Be clear, concise, and detailed for easy following
    - Improve on the current prompt with more details and specificity
    - Let me know if any part of the prompt needs clarification

    Return optimal prompt instruction. Keep it short and sweet.
    Here is the prompt string you need to improve:
    ]=]


    local prompt_instruction = string.format(instruction, vim.bo.filetype)
    local bufnr = vim.api.nvim_get_current_buf()
    cody_commands.do_task(bufnr, start_line, end_line, prompt_instruction)
end

vim.api.nvim_create_user_command("CodyImprovePromptInstruction", function()
    local start_line, end_line = get_selection_lines()
    improve_prompt_instruction(start_line, end_line)
end, {
    nargs = 0,
    range = true,
})

--- Generate commit message for current changes
local function generate_commit_message()
    local instruction = [=[
        Cody, generate a commit message for the current changes.

    You are provided the following staged changes:

    %s

    Please generate a commit message that:

    - Concisely summarizes the changes in the diff
    - Uses conventional commit types like feat, fix, docs etc.
    - Omits minor or unnecessary details
    - Follows Conventional Commits spec: https://www.conventionalcommits.org/

    The commit message should:
    - Be short, clear and easy to understand
    - Explain what was changed and why
    - Follow best practices for formatting and style

    Bellow suggest more optimal prompt instruction for this task.
    ]=]

    local git_diff = vim.fn.system("git diff --staged")
    cody_commands.do_task(
        vim.api.nvim_get_current_buf(),
        0,
        1,
        string.format(instruction, git_diff)
    )
end

vim.api.nvim_create_user_command("CodyGenerateCommitMessage", function()
    generate_commit_message()
end, {
    nargs = 0,
})


local insturcio



---@param start_line number
---@param end_line number
local function add_lua_type_annotations(start_line, end_line)
    local instruction = [=[
    Hey, Cody! Let make you to act as a Senior Type Annotator for the Lua code.
    Here the guide page where you could see how I want the code to be annotated:
    ```markdown
    %s
    ```
    ---
    Generate type annotations with following recommendations:
    - Follow neovim community conventions for type annotations.
    - Add a general comment above the code snippet to explain the purpose of the code.
    - if function void, then add return type `nil`
    - Do not add type annotations for function calls, only for function definitions.
    - Add type annotations for all function arguments and return values.
    - Keep type annotations above the function definition.
    - Do not add newlines!
    - Update only the provided code snippet.
    ]=]

    local guide = vim.fn.readfile(vim.fn.stdpath("config") .. "/prompts/lua_type_annotations.txt")
    local prompt_instruction = string.format(instruction, table.concat(guide, "\n"))
    local bufnr = vim.api.nvim_get_current_buf()
    local selected_lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
    vim.notify(table.concat(selected_lines, "\n"))
    cody_commands.do_task(bufnr, start_line - 1, end_line, prompt_instruction)
end

vim.api.nvim_create_user_command("CodyAddTypeAnnotations", function()
    local start_line, end_line = get_selection_lines()
    add_lua_type_annotations(start_line, end_line)
end, {
    nargs = 0,
    range = true,
})


-- Ask Cody to optiviaze the chunk of code to make it blazing fast, and more idiomatic.
local function optimize_lua_code(start_line, end_line)
    local instruction = [=[
    Cody, optimize only the provided code snippet.
    Keep in mind that this is a small part of a larger codebase.
    So you should not change any existing code, only optimize the provided snippet.
    Or suggest a better way to do it, unless you see is already perfect.

    Please optimize this chunk of code:

        - Performance - use optimal algorithms and data structures. Avoid unnecessary loops, recursion, and other complex code
    - Readability - follow %s style guides and conventions
       - Specifically for Lua:
           - If you see `vim` that means that lua code is using neovim.API. Then its "LuaJIT" flavor is used.
           - Add type annotations and documentation to support the Lua language server from sumneko.
           - Add usage example in comments with asserts above the function.
           ---local notes = Notes():with_title_mismatched()
           ---local note = notes:get_random_note()
           ---assert(note.data.title ~= note.data.stem)

        - Maintainability - modularize into focused functions with docs. Avoid global variables and other anti-patterns.
    - Clarity - add types and comments explaining complex sections. If it's not clear, it's not optimized!
    - Formatting - proper indentation, whitespace, 100 char line length, etc.

    The optimized code should:
    - Be blazing fast. Performance is the top priority!
    - Be idiomatic and conform to %s best practices.
        - Have logical, modular functions and components, but don't do dumb wrappings and other anti-patterns.
    - Contain annotations and docs for understanding complex sections.
    - Explain optimizations in comments above the code if it's not obvious.
    - Be properly formatted and indented

    Give the explanation for the optimizations you made in mulitline comment above the code.
    Let me know if any part of the prompt needs clarification!
    Like in this example:
    "Optimizations:

    - Use string.format instead of concatenation for performance
    - Cache the osascript command format string since it doesn't change
    - Use vim.cmd over vim.fn.system since we don't need the output
    - Add comments explaining the purpose and optimizations
    ]=]
    local filetype = vim.bo.filetype
    if filetype == "lua" then
        filetype = filetype .. " " .. get_lua_version()
    end
    local prompt_instruction = string.format(instruction, filetype, filetype, filetype, filetype)

    local bufnr = vim.api.nvim_get_current_buf()
    cody_commands.do_task(bufnr, start_line, end_line, prompt_instruction)
end

vim.api.nvim_create_user_command("CodyOptimizeCode", function()
    optimize_lua_code(get_selection_lines())
end, {
    nargs = 0,
    range = true,
})

local function improve_documentation(start_line, end_line)
    local instruction = [=[
    Cody, improve documentation for the provided code snippet.

    Please improve documentation for this chunk of code:

    ]=]
    local prompt_instruction = string.format(instruction, vim.bo.filetype)
    local bufnr = vim.api.nvim_get_current_buf()
    cody_commands.ask(prompt_instruction)
end


local function cody_hard_reset()
    require("sg.cody.commands").chat(_, {
        reset = true,
    })
    vim.cmd("q!")
    vim.cmd("CodyRestart")
end

vim.api.nvim_create_user_command("CodyReset", function()
    cody_hard_reset()
end, {
    nargs = 0,
})


--- Sometimes I have a code snippet where "--to be implemented" is written.
--- or "TODO: implement this function"
--- or any other comment that indicates that this code is not ready.
--- Maybe there only human only comments like "We do this yada yada yada"
--- So I want to ask Cody to try to implement this code with explanation,
--- and focus on blazing fast performance.

vim.api.nvim_create_user_command("CodySolveCommentedInstruction", function()
    -- The good prompt instruction for this task is:
    local instruction = [=[
    Cody, implement the commented code snippet.
    Keep in mind that this is a small part of a larger codebase.
    So you should not change any existing code, only implement the provided snippet.
    Or suggest a better way to do it, unless you see is already perfect.
    Focus on blazing fast performance and best practices for that language, and community conventions.

    Please implement this chunk of code:

    ]=]
    local prompt_instruction = string.format(instruction, vim.bo.filetype)
    local bufnr = vim.api.nvim_get_current_buf()
    cody_commands.do_task(bufnr, start_line, end_line, prompt_instruction)
end, {
    nargs = 0,
    range = true,
})


local function improve_performance(start_line, end_line)
    local instruction = [=[
    Cody, improve performance for the provided code snippet.
    Make it blazing fast, the fastest possible(but still idiomatic).
    Keep in mind that this is a small part of a larger codebase.
    So you should not change any existing code, only optimize the provided snippet.
    Or suggest a better way to do it, unless you see is already perfect.

    Please improve performance for this chunk of code:

    ]=]
    local prompt_instruction = string.format(instruction, vim.bo.filetype)
    local bufnr = vim.api.nvim_get_current_buf()
    cody_commands.do_task(bufnr, start_line, end_line, prompt_instruction)
end

vim.api.nvim_create_user_command("CodyBlazingFast", function()
    improve_performance(get_selection_lines())
end, {
    nargs = 0,
    range = true,
})
