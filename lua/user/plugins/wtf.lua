require("wtf").setup({
    -- Default AI popup type
    popup_type = "popup",
    -- An alternative way to set your API key
    openai_api_key = vim.env.OPENAI_API_KEY,
    -- ChatGPT Model
    openai_model_id = "gpt-3.5-turbo",
    -- Send code as well as diagnostics
    context = true,
    -- Set your preferred language for the response
    language = "english",
    -- Any additional instructions
    additional_instructions = "Start the reply with short neovim(advanced!) random tip!",
    -- Default search engine, can be overridden by passing an option to WtfSeatch
    search_engine = "google",
    -- Callbacks
    hooks = {
        request_started = nil,
        request_finished = nil,
    },
    -- Add custom colours
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
})
