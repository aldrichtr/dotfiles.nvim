
local M = {}
setmetatable(M, {
  __index = M,
  __call  = function(cls, ...) return cls:init(...) end
})

function M:init(opts)
  if vim.fn.executable('pwsh') == 1 then
    vim.opt.shell = 'pwsh'
  elseif vim.fn.executable('powershell') then
    vim.opt.shell = 'powershell'
  end
    -- These are passed to the shell when running `!` and `:!`
    vim.opt.shellcmdflag = table.concat({
      '-NoLogo',
      '-NoProfile',
      '-ExecutionPolicy RemoteSigned',
      '-Command',
      '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();',
      [[$PSDefaultParameterValues['Out-File:Encoding']='utf8';]],
      'Remove-Alias -Force -ErrorAction SilentlyContinue tee;',
    }, ' ')
    vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    vim.opt.shellquote = ''
    vim.opt.shellxquote = ''
    vim.opt.shellslash = true
end


return M
