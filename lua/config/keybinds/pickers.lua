
local M = {}

M.whichkey = {
  { mode = { 'n' }, { '<leader>bb', function() Snacks.picker.buffers() end, desc = 'Buffers' } },
  {
    mode = { 'n' },
    { ',<space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    { ',/', function() Snacks.picker.grep() end, desc = 'Grep' },
    { ',:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { ',n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
    { ',0', function() Snacks.explorer() end, desc = 'File Explorer' },
    { ',ve', function() Snacks.explorer() end, desc = 'File Explorer' },
    -- find
    {
      ',fc',
      function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end,
      desc = 'Find Config File',
    },
    { ',ff', function() Snacks.picker.files() end, desc = 'Find Files' },
    { ',fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
    { ',fp', function() Snacks.picker.projects() end, desc = 'Projects' },
    { ',fr', function() Snacks.picker.recent() end, desc = 'Recent' },
    -- git
    { ',gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { ',gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
    { ',gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
    { ',gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
    { ',gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
    { ',gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
    { ',gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },
    -- gh
    { ',gi', function() Snacks.picker.gh_issue() end, desc = 'GitHub Issues (open)' },
    { ',gI', function() Snacks.picker.gh_issue({ state = 'all' }) end, desc = 'GitHub Issues (all)' },
    { ',gp', function() Snacks.picker.gh_pr() end, desc = 'GitHub Pull Requests (open)' },
    { ',gP', function() Snacks.picker.gh_pr({ state = 'all' }) end, desc = 'GitHub Pull Requests (all)' },
    {
      ',sw',
      function() Snacks.picker.grep_word() end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
  },
  {
    group = 'Search',
    { ',s"', function() Snacks.picker.registers() end, desc = 'Registers' },
    { ',s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
    { ',sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
    { ',sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { ',sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    { ',sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { ',sC', function() Snacks.picker.commands() end, desc = 'Commands' },
    { ',sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { ',sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
    { ',sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
    { ',sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
    { ',si', function() Snacks.picker.icons() end, desc = 'Icons' },
    { ',sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
    { ',sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { ',sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
    { ',sm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { ',sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
    { ',sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
    { ',sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
    { ',sR', function() Snacks.picker.resume() end, desc = 'Resume' },
    { ',su', function() Snacks.picker.undo() end, desc = 'Undo History' },
  },
  {
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
    { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
    { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
    { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
    { 'gai', function() Snacks.picker.lsp_incoming_calls() end, desc = 'C[a]lls Incoming' },
    { 'gao', function() Snacks.picker.lsp_outgoing_calls() end, desc = 'C[a]lls Outgoing' },
    { ',ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
    { ',sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
  },
  {
    { ',uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
  },
}

return M
