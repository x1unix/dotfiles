-- Configure the TypeScript server settings for use with typescript-tools
-- Note: This file is NOT used with vim.lsp.config since typescript-tools replaces tsserver LSP
--
-- Inspired by: https://github.com/H4ckint0sh/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/typescript.lua

local filterReactDTS = function(value)
  -- Depending on typescript version either uri or targetUri is returned
  if value.uri then
    return string.match(value.uri, '%.d.ts') == nil
  elseif value.targetUri then
    return string.match(value.targetUri, '%.d.ts') == nil
  end
end

local filter = function(arr, fn)
  if type(arr) ~= 'table' then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local handlers = {
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  }),
  ['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = true }
  ),
  ['textDocument/definition'] = function(err, result, method, ...)
    if vim.islist(result) and #result > 1 then
      local filtered_result = filter(result, filterReactDTS)
      return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
    end

    vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
  end,
}

local settings = {
  -- Performance settings
  separate_diagnostic_server = true,
  publish_diagnostic_on = 'insert_leave',
  tsserver_max_memory = 'auto',

  -- Formatting preferences (from default_format_options)
  tsserver_format_options = {
    insertSpaceAfterCommaDelimiter = true,
    insertSpaceAfterConstructor = false,
    insertSpaceAfterSemicolonInForStatements = true,
    insertSpaceBeforeAndAfterBinaryOperators = true,
    insertSpaceAfterKeywordsInControlFlowStatements = true,
    insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
    insertSpaceBeforeFunctionParenthesis = false,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
    insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
    insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
    insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
    insertSpaceAfterTypeAssertion = false,
    placeOpenBraceOnNewLineForFunctions = false,
    placeOpenBraceOnNewLineForControlBlocks = false,
    semicolons = 'ignore',
    indentSwitchCase = true,
  },

  -- File preferences (combining your inlay hints with default preferences)
  tsserver_file_preferences = {
    -- Your current inlay hint settings
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = false,
    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
    includeInlayPropertyDeclarationTypeHints = false,
    includeInlayFunctionLikeReturnTypeHints = false,
    includeInlayEnumMemberValueHints = true,

    -- Important default preferences
    quotePreference = 'auto',
    importModuleSpecifierEnding = 'auto',
    jsxAttributeCompletionStyle = 'auto',
    allowTextChangesInNewFiles = true,
    providePrefixAndSuffixTextForRename = true,
    allowRenameOfImportPath = true,
    includeAutomaticOptionalChainCompletions = true,
    provideRefactorNotApplicableReason = true,
    generateReturnInDocTemplate = true,
    includeCompletionsForImportStatements = true,
    includeCompletionsWithSnippetText = true,
    includeCompletionsWithClassMemberSnippets = true,
    includeCompletionsWithObjectLiteralMethodSnippets = true,
    useLabelDetailsInCompletionEntries = true,
    allowIncompleteCompletions = true,
    displayPartsForJSDoc = true,
    disableLineTextInReferences = true,
  },

  -- Feature settings
  expose_as_code_action = 'all',
  complete_function_calls = false,
  include_completions_with_insert_text = true,
  code_lens = 'off',
}

local on_attach = function(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr })
end

return {
  handlers = handlers,
  settings = settings,
  on_attach = on_attach,
}
