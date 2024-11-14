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

local function get_gnopls()
  local gnopls = os.getenv('GNOPLS_BIN')
  if gnopls and gnopls ~= "" then
    return gnopls
  end

  return vim.fn.exepath("gnopls")
end

local function start_gnopls(args)
  local gnopls_bin = get_gnopls()
  if gnopls == "" then
    print("Error: can't find gnopls!")
    return
  end

  local gnoroot = get_gnoroot()
  if gnoroot == "" then
    print("Error: can't find GNOROOT, is Gno installed?")
    return
  end

  print("Starting gopls...")
  vim.lsp.start({
      name = 'gnopls',
      cmd = { gnopls_bin, 'serve', '--gnoroot', gnoroot },
      -- root_dir = vim.fs.root(args.buf, { 'gno.mod', '.git' }),
  })
end

local function register_gno()
  vim.api.nvim_create_autocmd('FileType', {
      pattern = 'gno',
      callback = function(args)
        start_gnopls(args)
      end,
  })
end

register_gno()

