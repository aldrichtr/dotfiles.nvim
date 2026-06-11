
local path = require('config.path')
local fs   = require('util.fs')
local class = require('extern.middleclass')
local Server = require('config.server')

local LuaServer = Server:subclass('LuaServer')


function LuaServer:initialize()
	Server.initialize(self)
	self.server = 'lua_ls'
end



function LuaServer:apply()
	---@type vim.lsp.config
	local config = {
		cmd = { fs.join(self.bin, 'lua-language-server.cmd') },
		filetypes = { "lua" },
		root_markers = {
			".luarc.json", ".luarc.jsonc",
			".stylua.toml", "stylua.toml",
		},
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = {
					globals = { "vim", "log", "Logger", "class" },
				},
			},
		},
	}

	Logger:info("Configuring %s Language Server", self.server)
	vim.lsp.config(self.server, config)
	vim.lsp.enable(self.server)
end
	

return LuaServer
