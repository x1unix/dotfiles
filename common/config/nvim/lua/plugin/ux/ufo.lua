-- UFO for folding.
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
--
-- See: https://github.com/kevinhwang91/nvim-ufo
return {
  {
    'kevinhwang91/nvim-ufo',
    lazy = false,
    dependencies = 'kevinhwang91/promise-async',
    -- See bug: https://github.com/kevinhwang91/nvim-ufo/issues/309
    -- version = 'v1.5.0',
    commit = '5b75cf5fdb74054fc8badb2e7ca9911dc0470d94',
    init = function()
      -- UFO folding config
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.opt.fillchars = {
        fold = ' ',
        foldopen = '▾',
        foldsep = '│',
        foldclose = '▸',
      }
    end,
    opts = {
      open_fold_hl_timeout = 0,
      -- Use builtin treesitter for folding provider
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,

      -- See: https://github.com/Jacky-Lzx/nvim.tutorial.config/blob/2385a41643b09973b5750ba680eaf056e4202b28/lua/plugins/ui.lua#L435C1-L462C11
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    },
    config = function(_, opts)
      require('ufo').setup(opts)
    end,
  },
}
