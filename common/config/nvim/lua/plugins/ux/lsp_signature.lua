---@class LspSignatureConfig
---@field bind? boolean Register the border config (mandatory in some cases)
---@field doc_lines? integer Number of documentation lines to show (0 = only signature)
---@field max_height? integer Max height of the floating window
---@field max_width? integer|fun():integer Max width of the floating window (can be a function)
---@field wrap? boolean Enable text wrapping in floating window
---@field floating_window? boolean Show hint in a floating window
---@field ignore_error? fun(err: any, ctx: any, config: LspSignatureConfig):boolean Callback to ignore certain errors
---@field floating_window_above_cur_line? boolean Try placing the floating window above the current line
---@field toggle_key_flip_floatwin_setting? boolean Toggle floating_window setting with key
---@field floating_window_off_x? integer|fun():integer Offset X for floating window position
---@field floating_window_off_y? fun(floating_opts: table):integer Offset Y for floating window position
---@field close_timeout? integer Timeout (ms) to close window after last parameter input
---@field fix_pos? boolean|fun(signatures: any, client: any):boolean Fix floating window position
---@field hint_enable? boolean Enable virtual hint
---@field hint_prefix? string Prefix for hint text
---@field hint_scheme? string Highlight scheme for hint
---@field hint_inline? fun():boolean Whether to use inline hint or not
---@field hi_parameter? string Highlight group for active parameter
---@field handler_opts? table Options for floating window handler (e.g., border type)
---@field cursorhold_update? boolean Update on CursorHold
---@field padding? string Padding character(s) for signature window
---@field always_trigger? boolean Always trigger signature help on new lines
---@field auto_close_after? number Auto-close signature after seconds (nil disables)
---@field check_completion_visible? boolean Adjust position relative to completion menu
---@field debug? boolean Enable debug logging
---@field log_path? string Path to log file
---@field verbose? boolean Show line numbers in debug
---@field extra_trigger_chars? string[] Extra characters to trigger signature help
---@field zindex? integer Z-index of floating window
---@field transparency? integer Transparency level of floating window
---@field shadow_blend? integer Opacity of shadow border
---@field shadow_guibg? string Background color for shadow border
---@field timer_interval? integer Timer interval for update checks
---@field toggle_key? string Toggle keybinding for signature display
---@field select_signature_key? string Keybinding to cycle signatures (e.g., for overloads)
---@field move_cursor_key? string Key to move cursor
---@field move_signature_window_key? string[] Keys to move the floating signature window
---@field show_struct? { enable: boolean } Experimental: show structure info
---@field winnr? number Internal use: floating window number
---@field bufnr? number Internal use: buffer number
---@field mainwin? number Internal use: main window ID

return {
  -- Show function signature when you type
  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    ---@type LspSignatureConfig
    opts = {
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    },
  },
}
