
local M = { name = 'clojure_lsp' }

function M.config(user_config) 
	return {
		cmd = vim.fs.joinpath(vim.env.LOCALAPPDATA, 'lsp', 'clojure', 'bin', 'clojure_lsp.exe'),
		filetypes = { 'clojure', 'edn' },
		root_markers = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git', 'bb.edn' }
	}
end


return M
