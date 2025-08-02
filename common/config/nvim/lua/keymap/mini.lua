local wk = require('which-key')

-- Leader
wk.add({
  { '<Leader>s', group = 'sessions' },
  {
    '<Leader>sl',
    function()
      require('mini.sessions').read(nil)
    end,
    mode = 'n',
    desc = 'Load local or latest global session',
  },
  {
    '<Leader>sr',
    function()
      require('mini.sessions').select('read')
    end,
    mode = 'n',
    desc = 'Pick & load session',
  },
  {
    '<Leader>ss',
    function()
      require('util.sessionutil').prompt_session_name(function(session_name)
        require('mini.sessions').write(session_name, { force = true })
      end)
    end,
    mode = 'n',
    desc = 'Save current session',
  },
  {
    '<Leader>sd',
    function()
      require('mini.sessions').select('delete', { force = true })
    end,
    mode = 'n',
    desc = 'Select & delete a session',
  },
})
