local function register_gno_formatter()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.gno",
    callback = function(args)
      local job = require('plenary.job')
      local bufnr = vim.api.nvim_get_current_buf()

      -- unlike "args.file", contains full file path.
      local filepath = vim.api.nvim_buf_get_name(bufnr)

      -- Format code and refresh the buffer
      job:new({
        command = "gofumpt",
        args = { filepath },
        on_exit = function(j, exit_code)
          if exit_code == 0 then
            vim.schedule(function()
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, j:result())
            end)
          else
            vim.schedule(function()
              vim.notify("Error running gofumpt", vim.log.levels.ERROR, {
                title = "Code Formatting",
              })
            end)
          end
        end,
      }):sync()
    end,
  })
end

local function get_gnoroot()
  local gnoroot = os.getenv('GNOROOT')
  if gnoroot and gnoroot ~= '' then
    return gnoroot
  end

  local gno_bin = vim.fn.exepath("gno")
  if gno_bin == "" then
    print("Error: Can't find Gno")
    return ''
  end

  gnoroot = vim.fn.system(gno_bin .. "env GNOROOT")
  gnoroot = vim.trim(gnoroot)
  return gnoroot
end

local function get_server(bin_name, env_name)
  local bin_path = os.getenv(env_name)
  if bin_path and bin_path ~= "" then
    return bin_path
  end

  return vim.fn.exepath(bin_name)
end

local function start_gno_lsp(args)
  local server_name = 'gnoverse-gopls'
  local server_bin = get_server(server_name, 'GNOPLS_BIN')
  if server_bin == "" then
    vim.notify("Error: can't find " .. server_name, vim.log.levels.ERROR, {
      title = "Gno LSP",
    })
    return
  end

--  local gnoroot = get_gnoroot()
--  if gnoroot == "" then
--    print("Error: can't find GNOROOT, is Gno installed?")
--    return
--  end

  vim.lsp.start({
      name = server_name,
      cmd = { server_bin, 'serve' },
      -- cmd = { gnopls_bin, 'serve', '--gnoroot', gnoroot },
      -- root_dir = vim.fs.root(args.buf, { 'gno.mod', '.git' }),
  })
end

local function register_gno()
  vim.treesitter.language.register('go', 'gno')
  vim.api.nvim_create_augroup("gno", { clear = true })
--  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
--    group = "gno",
--    pattern = "*.gno",
--    callback = function ()
--      vim.cmd("set filetype=gno")
--    end
--  })
  register_gno_formatter()
  vim.api.nvim_create_autocmd('FileType', {
      pattern = 'gno',
      callback = function(args)
        start_gno_lsp(args)
      end,
  })
end

register_gno()

