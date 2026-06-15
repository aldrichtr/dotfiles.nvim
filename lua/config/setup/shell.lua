
local class = require('extern.middleclass')
local Config = require('config')

local Shell = class('Shell', Config)

function Shell:initialize()
  Config.initialize(self)
end

function Shell:apply()
  vim.opt.shelltemp = false

  vim.opt.shell = 'pwsh'

  vim.opt.shellcmdflag = [[ '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
                           '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
                           '$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
                           '$PSStyle.OutputRendering = ''PlainText'';'
                           ]]

  vim.opt.shellpipe  = '> %s 2>&1'

  vim.opt.shellquote= ''
  vim.opt.shellxquote= ''
end


return Shell
