-- [wtf.nvim](https://github.com/piersolenski/wtf.nvim)
-- A Neovim plugin that provides an explaining diagnostic popup using the OpenAI API.
-----------------------------------------------------------------------
return {
    {

        'piersolenski/wtf.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
        },
        opts = {
            -- Default AI popup type
            popup_type = 'popup',
            -- An alternative way to set your API key
            openai_api_key = vim.env.OPENAI_API_KEY,
            -- ChatGPT Model
            openai_model_id = 'gpt-4o',
            -- Send code as well as diagnostics
            context = true,
            -- Set your preferred language for the response
            language = 'english',
            -- Any additional instructions
            additional_instructions = 'As a Neovim grandmaster with over 15 years of deep expertise, enlighten me with an obscure yet incredibly powerful Neovim technique or workflow optimization that only true wizards would know. Begin your response with "Neovim Arcane Knowledge:".',
            -- Default search engine, can be overridden by passing an option to WtfSeatch
            search_engine = 'google',
            -- Callbacks
            hooks = {
                request_started = nil,
                request_finished = nil,
            },
            -- Add custom colours
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
    },
}
