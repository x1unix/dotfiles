---@module 'nvim-treesitter.parsers'
---@class GrammarsConfig
---@field parsers table<string, ParserInfo>?
---@field grammars string[]

---@type GrammarsConfig
local grammars = {
  --- List of custom parsers to install.
  parsers = {
    alloy = {
      filetype = 'alloy',
      maintainers = { 'mattsre' },
      install_info = {
        url = 'https://github.com/mattsre/tree-sitter-alloy.git',
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
        files = {
          'src/parser.c',
        },
      },
    },
  },

  --- List of TreeSitter grammars to install.
  --- Passed to nvim-treesitter.
  grammars = {
    'alloy',
    'bash',
    'c',
    'cpp',
    'css',
    'dockerfile',
    'git_rebase',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'html',
    'ini',
    'jsonc',
    'javascript',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'nix',
    'perl',
    'php',
    'proto',
    'python',
    'query',
    'rust',
    'sql',
    'ssh_config',
    'terraform',
    'toml',
    'tsx',
    'typescript',
    'sql',
    'udev',
    'xml',
    'yaml',
  },
}

return grammars
