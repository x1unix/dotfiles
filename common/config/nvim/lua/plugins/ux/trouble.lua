-- Trouble.nvim
-- A pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.
--
-- See: https://github.com/folke/trouble.nvim/blob/main/docs/examples.md

return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {
      modes = {
        test = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.3,
          },
        },
      },
    },
    init = function()
      -- Use trouble as quickfix list viewer
      vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        callback = function()
          vim.print('hook!')
          vim.cmd([[Trouble qflist open]])
        end,
      })

      -- Intercept and replace stock quickfixlist with Trouble
      vim.api.nvim_create_autocmd('BufRead', {
        callback = function(ev)
          local win = vim.api.nvim_get_current_win()
          local info = (vim.fn.getwininfo(win) or {})[1]
          if not info or info.quickfix ~= 1 then
            return
          end

          local is_loc = info.loclist == 1
          if vim.bo[ev.buf].buftype ~= 'quickfix' then
            return
          end

          -- Do in a current tick to prevent qf display for 100ms.
          vim.api.nvim_win_close(win, true)
          local ok, trouble = pcall(require, 'trouble')
          if ok then
            trouble.open({ mode = is_loc and 'loclist' or 'quickfix', focus = true })
            return
          end

          vim.schedule(function()
            vim.cmd([[Trouble qflist open]])
          end)
        end,
      })
      -- End of qf hook
    end,
  },
}
