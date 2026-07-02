
local M = {}

function M:setup()
	vim.opt.shelltemp = false
	vim.opt.shell = 'pwsh'
	vim.opt.shellpipe = '> %s 2>&1'
	vim.opt.shellquote = ''
	vim.opt.shellxquote = ''
	vim.opt.shellcmdflag = [[ '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
                           '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
                           '$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
                           '$PSStyle.OutputRendering = ''PlainText'';'
                           ]]
end


return M
