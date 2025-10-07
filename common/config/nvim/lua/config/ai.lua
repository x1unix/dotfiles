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
    provider = 'gemini-cli',
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
        model = 'anthropic/claude-sonnet-4',
      },
    },
    input = {
      -- See: https://github.com/yetone/avante.nvim#input-provider-configuration
      provider = 'snacks',
    },
  },
}
