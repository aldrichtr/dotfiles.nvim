
local path = require('util.path')
local is   = require('util.is')

local M = { name = 'clojure_lsp' }

function M.config(user_config)
  local root = path.join(path.lsp, M.name)
  local lsp_config = {
    cmd = path.join(root, 'bin', 'clojure_lsp.exe'),
    filetypes = { 'clojure' },
    root_markers = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git', 'bb.edn' }
  }

	if is.present(user_config) then
		vim.tbl_deep_extend('force', lsp_config, user_config)
	end

  return lsp_config
end


return M
