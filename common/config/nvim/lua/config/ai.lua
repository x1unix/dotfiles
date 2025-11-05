return {
  enabled = true,

  -- List of providers that I use. It's a subset of supported Avante providers.
  --
  -- Used in provider switcher dialog.
  enabled_providers = {
    'gemini',
    'gemini-cli',
    'openrouter',
  },

  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- provider = 'gemini-cli',
    provider = 'openrouter',
    acp_providers = {
      ['gemini-cli'] = {
        command = 'gemini',
        args = { '--experimental-acp' },
        env = {
          NODE_NO_WARNINGS = '1',
          GEMINI_API_KEY = os.getenv('GEMINI_API_KEY'),
        },
      },
    },
    providers = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = 'google/gemini-2.5-flash',
        model_names = {
          'anthropic/claude-sonnet-4',
          'anthropic/claude-sonnet-4.5',
          'x-ai/grok-code-fast-1',
          'google/gemini-2.5-flash',
          'google/gemini-2.0-flash-001',
          'google/gemini-2.5-pro',
          'google/gemma-3-12b-it',
          'openai/gpt-oss-120b',
          'openai/gpt-4o-mini',
          'deepseek/deepseek-chat-v3-0324',
          'qwen/qwen3-235b-a22b-2507',
          'mistralai/codestral-2508',
          'z-ai/glm-4.6',
          'minimax/minimax-m2:free',
        },
      },
    },
    input = {
      -- See: https://github.com/yetone/avante.nvim#input-provider-configuration
      provider = 'snacks',
    },
  },
}
