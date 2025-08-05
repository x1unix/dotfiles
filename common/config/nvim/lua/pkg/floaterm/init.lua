---@class FloatermConfig
---@field width? number Window width as fraction of screen (0.0-1.0)
---@field height? number Window height as fraction of screen (0.0-1.0)
---@field border? "none"|"single"|"double"|"rounded"|"solid"|"shadow" Border style
---@field keymap? string Keymap to toggle terminal (default: "<Leader>`")

---@class Floaterm
local M = {}

-- State variables
---@type number|nil
local popup_buf = nil
---@type number|nil
local popup_win = nil
---@type number|nil
local term_job_id = nil

-- Default configuration
---@type FloatermConfig
local config = {
  width = 0.8, -- 80% of screen width
  height = 0.6, -- 60% of screen height
  border = 'rounded',
  keymap = '<Leader>`', -- Default keymap
}

-- Close popup window
---@return nil
local function close_popup()
  if popup_win and vim.api.nvim_win_is_valid(popup_win) then
    vim.api.nvim_win_close(popup_win, false)
    popup_win = nil
  end
end

-- Create popup window
---@return nil
local function create_popup()
  -- Calculate dimensions
  local width = math.floor(vim.o.columns * config.width)
  local height = math.floor(vim.o.lines * config.height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Always create a fresh buffer if terminal has exited
  if not popup_buf or not vim.api.nvim_buf_is_valid(popup_buf) or not term_job_id then
    -- Delete old buffer if it exists
    if popup_buf and vim.api.nvim_buf_is_valid(popup_buf) then
      vim.api.nvim_buf_delete(popup_buf, { force = true })
    end

    popup_buf = vim.api.nvim_create_buf(false, true)
    term_job_id = nil -- Ensure job id is reset

    -- Set buffer options
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = popup_buf })
  end

  -- Create window
  popup_win = vim.api.nvim_open_win(popup_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = config.border,
  })

  -- Winblend controls window transparency
  vim.api.nvim_set_option_value('winblend', 0, { win = popup_win })

  -- Set buffer-specific keymaps
  vim.keymap.set('t', '<Esc>', function()
    close_popup()
  end, {
    buffer = popup_buf,
    desc = 'Close popup terminal from terminal mode',
    silent = true,
  })

  -- TODO: figure out a keybind for this
  -- vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {
  --   buffer = popup_buf,
  --   desc = 'Exit terminal mode',
  --   silent = true,
  -- })

  -- Start terminal if not already running
  if not term_job_id then
    -- Switch to the terminal buffer and start terminal
    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_buf(popup_buf)

    term_job_id = vim.fn.jobstart(vim.o.shell, {
      term = true,
      on_exit = function(job_id, exit_code, event_type)
        -- Reset job id since the process has exited
        term_job_id = nil
        -- Auto-close popup when shell exits
        vim.schedule(function()
          if popup_win and vim.api.nvim_win_is_valid(popup_win) then
            close_popup()
          end
        end)
      end,
    })

    vim.api.nvim_set_current_buf(current_buf)
  end

  -- Enter insert mode in terminal
  vim.cmd('startinsert')
end

-- Toggle popup terminal
---@return nil
function M.toggle()
  if popup_win and vim.api.nvim_win_is_valid(popup_win) then
    close_popup()
  else
    create_popup()
  end
end

-- Setup function to initialize the plugin
---@param opts? FloatermConfig User configuration to merge with defaults
---@return nil
function M.setup(opts)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend('force', config, opts or {})

  -- Set up global keymapping for toggle
  vim.keymap.set('n', config.keymap, M.toggle, {
    desc = 'Toggle floating terminal',
    silent = true,
  })

  -- Auto-close popup when leaving buffer (optional)
  vim.api.nvim_create_autocmd('BufLeave', {
    callback = function()
      if popup_win and vim.api.nvim_win_is_valid(popup_win) then
        local current_buf = vim.api.nvim_get_current_buf()
        if current_buf == popup_buf then
          close_popup()
        end
      end
    end,
  })
end

---@return Floaterm
return M
