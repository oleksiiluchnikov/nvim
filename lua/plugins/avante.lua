local M = {}
local base = {
    timeout = 30000,
}
local role_map = {
    user = 'human',
    assistant = 'assistant',
    system = 'system',
}

local parse_messages = function(opts)
    local messages = {
        { role = 'system', content = opts.system_prompt },
    }
    vim.iter(opts.messages):each(function(msg)
        table.insert(
            messages,
            { speaker = role_map[msg.role], text = msg.content }
        )
    end)
    return messages
end

local parse_response = function(data_stream, event_state, opts)
    if event_state == 'done' then
        opts.on_complete()
        return
    end

    if data_stream == nil or data_stream == '' then
        return
    end

    local json = vim.json.decode(data_stream)
    local delta = json.deltaText
    local stopReason = json.stopReason

    if stopReason == 'end_turn' then
        return
    end

    opts.on_chunk(delta)
end

---@type AvanteProvider
local cody = {
    endpoint = 'https://sourcegraph.com',
    model = 'anthropic::2024-10-22::claude-3-5-sonnet-latest',
    api_key_name = 'SRC_ACCESS_TOKEN',
    --- This function below will be used to parse in cURL arguments.
    --- It takes in the provider options as the first argument, followed by code_opts retrieved from given buffer.
    --- This code_opts include:
    --- - question: Input from the users
    --- - code_lang: the language of given code buffer
    --- - code_content: content of code buffer
    --- - selected_code_content: (optional) If given code content is selected in visual mode as context.
    ---@type fun(provider_opts: AvanteProvider, prompt_opts: AvantePromptOptions): AvanteCurlOutput
    parse_curl_args = function(provider_opts, prompt_opts)
        local headers = {
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'token ' .. os.getenv('SRC_ACCESS_TOKEN'),
        }

        return {
            url = 'https://sourcegraph.com/.api/completions/stream?api-version=2&client-name=web&client-version=0.0.1',
            timeout = base.timeout,
            insecure = false,
            headers = headers,
            body = vim.tbl_deep_extend('force', {
                model = 'anthropic::2024-10-22::claude-3-5-sonnet-latest',
                temperature = 0,
                topK = -1,
                topP = -1,
                maxTokensToSample = 4000,
                stream = true,
                messages = parse_messages(prompt_opts),
            }, {}),
        }
    end,
    parse_response = parse_response,
    parse_messages = parse_messages,
}

return {
    {
        'yetone/avante.nvim',
        event = 'VeryLazy',
        lazy = false,
        version = '*',
        opts = {
            ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
            -- provider = 'openai', -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
            provider = 'copilot',
            auto_suggestions_provider = 'copilot', -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
            ---@type AvanteProvider
            copilot = {
                model = 'claude-3.5-sonnet',
                timeout = 5000, -- Timeout in milliseconds
                temperature = 0.6, -- Temperature for the model
            },
            openai = {
                endpoint = 'https://openrouter.ai/api/v1',
                model = 'openai/gpt-4o',
                api_key_name = 'OPENROUTER_API_KEY',
            },
            vendors = {
                openrouter_cs35 = {
                    __inherited_from = 'openai',
                    api_key_name = 'OPENROUTER_API_KEY',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'anthropic/claude-3.5-sonnet:beta',
                    temperature = 0.2,
                    max_tokens = 8192,
                },
                openrouter_gemini = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'google/gemini-2.0-flash-001',
                    api_key_name = 'OPENROUTER_API_KEY',
                },
                openrouter_o3_mini = {
                    __inherited_from = 'openai',
                    api_key_name = 'OPENROUTER_API_KEY',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'openai/o3-mini',
                    temperature = 0.2,
                    max_tokens = 8192,
                },
                openrouter_haiku = {
                    __inherited_from = 'openai',
                    api_key_name = 'OPENROUTER_API_KEY',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'anthropic/claude-3.5-haiku:beta',
                    temperature = 0.2,
                    max_tokens = 8192,
                },
                openrouter_deepseek_r1 = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'deepseek/deepseek-r1',
                    api_key_name = 'OPENROUTER_API_KEY',
                    temperature = 0.2, -- Temperature for the model
                    max_tokens = 4096, -- Maximum tokens to generate
                },
                openrouter_deepseek_coder = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'deepseek/deepseek-coder',
                    api_key_name = 'OPENROUTER_API_KEY',
                },

                openrouter_deepseek_chat = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'deepseek/deepseek-chat',
                    api_key_name = 'OPENROUTER_API_KEY',
                },
                openrouter_gemini2_flash = {
                    __inherited_from = 'openai',
                    api_key_name = 'OPENROUTER_API_KEY',
                    endpoint = 'https://openrouter.ai/api/v1',
                    model = 'google/gemini-2.0-flash-exp:free',
                },
                ['cody'] = {
                    endpoint = 'https://sourcegraph.com',
                    model = 'anthropic::2024-10-22::claude-3-5-sonnet-latest',
                    api_key_name = 'SRC_ACCESS_TOKEN',
                    parse_curl_args = function(provider_opts, prompt_opts)
                        local headers = {
                            ['Content-Type'] = 'application/json',
                            ['Authorization'] = 'token '
                                .. os.getenv('SRC_ACCESS_TOKEN'),
                        }

                        return {
                            url = 'https://sourcegraph.com/.api/completions/stream?api-version=2&client-name=web&client-version=0.0.1',
                            timeout = base.timeout,
                            insecure = false,
                            headers = headers,
                            body = vim.tbl_deep_extend('force', {
                                model = 'anthropic::2024-10-22::claude-3-5-sonnet-latest',
                                temperature = 0,
                                topK = -1,
                                topP = -1,
                                maxTokensToSample = 4000,
                                stream = true,
                                messages = parse_messages(prompt_opts),
                            }, {}),
                        }
                    end,
                    parse_response = parse_response,
                    parse_messages = parse_messages,
                },
                -- openrouter_gemini15_flash = {
                --     __inherited_from = 'openai',
                --     api_key_name = 'OPENROUTER_API_KEY',
                --     endpoint = 'https://openrouter.ai/api/v1',
                --     model = 'google/gemini-1.5-flash-exp:free',
                -- },
                ---@type AvanteProvider
                -- ['cody'] = cody,
                --- This function below will be used to parse in cURL arguments.
                --- It takes in the provider options as the first argument, followed by code_opts retrieved from given buffer.
                --- This code_opts include:
                --- - question: Input from the users
                --- - code_lang: the language of given code buffer
                --- - code_content: content of code buffer
                --- - selected_code_content: (optional) If given code content is selected in visual mode as context.
                ---@type fun(opts: AvanteProvider, code_opts: AvantePromptOptions): AvanteCurlOutput
                -- parse_curl_args = function(opts, code_opts)
                --     local headers = {
                --         ['Content-Type'] = 'application/json',
                --         ['Authorization'] = 'token '
                --             .. os.getenv(opts.api_key_name),
                --     }
                --
                --     return {
                --         url = opts.endpoint
                --             .. '/.api/completions/stream?api-version=2&client-name=web&client-version=0.0.1',
                --         timeout = base.timeout,
                --         insecure = false,
                --         headers = headers,
                --         body = vim.tbl_deep_extend('force', {
                --             model = opts.model,
                --             temperature = 0,
                --             topK = -1,
                --             topP = -1,
                --             maxTokensToSample = 4000,
                --             stream = true,
                --             messages = M.parse_messages(code_opts),
                --         }, {}),
                --     }
                -- end,
                -- parse_response = M.parse_response,
                -- parse_messages = M.parse_messages,
            },

            -- copilot = {
            --     endpoint = 'https://api.githubcopilot.com',
            --     model = 'claude-3-5-sonnet',
            --     proxy = nil, -- [protocol://]host[:port] Use this proxy
            --     allow_insecure = false, -- Allow insecure server connections
            --     timeout = 30000, -- Timeout in milliseconds
            --     temperature = 0,
            --     max_tokens = 4096,
            -- },
            ---Specify the special dual_boost mode
            ---1. enabled: Whether to enable dual_boost mode. Default to false.
            ---2. first_provider: The first provider to generate response. Default to "openai".
            ---3. second_provider: The second provider to generate response. Default to "claude".
            ---4. prompt: The prompt to generate response based on the two reference outputs.
            ---5. timeout: Timeout in milliseconds. Default to 60000.
            ---How it works:
            --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
            ---Note: This is an experimental feature and may not work as expected.
            dual_boost = {
                enabled = false,
                first_provider = 'openai',
                second_provider = 'claude',
                prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
                timeout = 60000, -- Timeout in milliseconds
            },
            behaviour = {
                auto_suggestions = true, -- Experimental stage
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
            mappings = {
                --- @class AvanteConflictMappings
                diff = {
                    ours = 'co',
                    theirs = 'ct',
                    all_theirs = 'ca',
                    both = 'cb',
                    cursor = 'cc',
                    next = ']x',
                    prev = '[x',
                },
                suggestion = {
                    accept = '<M-l>',
                    next = '<M-]>',
                    prev = '<M-[>',
                    dismiss = '<C-]>',
                },
                jump = {
                    next = ']]',
                    prev = '[[',
                },
                submit = {
                    normal = '<CR>',
                    insert = '<C-s>',
                },
                sidebar = {
                    apply_all = 'A',
                    apply_cursor = 'a',
                    switch_windows = '<Tab>',
                    reverse_switch_windows = '<S-Tab>',
                },
            },
            hints = { enabled = true },
            windows = {
                ---@type "right" | "left" | "top" | "bottom"
                position = 'right', -- the position of the sidebar
                wrap = true, -- similar to vim.o.wrap
                width = 50, -- default % based on available width
                sidebar_header = {
                    enabled = false, -- true, false to enable/disable the header
                    align = 'center', -- left, center, right for title
                    rounded = true,
                },
                input = {
                    prefix = '> ',
                    height = 30, -- Height of the input window in vertical layout
                },
                edit = {
                    border = 'rounded',
                    start_insert = true, -- Start insert mode when opening the edit window
                },
                ask = {
                    floating = true, -- Open the 'AvanteAsk' prompt in a floating window
                    start_insert = true, -- Start insert mode when opening the ask window
                    border = 'rounded',
                    ---@type "ours" | "theirs"
                    focus_on_apply = 'ours', -- which diff to focus after applying
                },
            },
            highlights = {
                ---@type AvanteConflictHighlights
                diff = {
                    current = 'DiffText',
                    incoming = 'DiffAdd',
                },
            },
            --- @class AvanteConflictUserConfig
            diff = {
                autojump = true,
                ---@type string | fun(): any
                list_opener = 'copen',
                --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
                --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
                --- Disable by setting to -1.
                override_timeoutlen = 500,
            },
            --- @class AvanteFileSelectorConfig
            file_selector = {
                --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
                provider = 'telescope',
                -- Options override for custom providers
                provider_opts = {},
            },
            suggestion = {
                debounce = 100,
                throttle = 100,
            },
        },
        keys = {
            {
                '<C-t>',
                ':AvanteToggle<CR>',
                { noremap = true, silent = true },
            },
        },

        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = 'make',
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'stevearc/dressing.nvim',
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            --- The below dependencies are optional,
            'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
            'zbirenbaum/copilot.lua', -- for providers='copilot'
            -- support for image pasting
            {
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { 'Avante' },
                },
                ft = { 'Avante' },
            },
            {
                'HakonHarnes/img-clip.nvim',
                event = 'VeryLazy',
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
        },
    },
}
