return {
  enabled = true,

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
        },
      },
    },
  },
}
