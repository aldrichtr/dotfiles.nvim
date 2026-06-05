
local path = require('config.path')
local fs      = require('util.fs')

local server = { name = 'clojure_lsp' }
local root = fs.join(path.lsp, server.name)

---@type vim.lsp.Config
server.config = {
  cmd  = fs.join(root, 'bin', 'clojure_lsp.exe'),
  filetypes = { 'clojure' },
  root_markers = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git', 'bb.edn' }
}

return server
