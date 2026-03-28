

local path = require("util.path")

local M = { name = "omnisharp" }

function M.config(user_config)
	return {
		cmd = {
			path.join(path.lsp.root, "omnisharp", "omnisharp.exe"),
			"-z",
			"--hostPID",
			vim.fn.getpid(),
			"'DotNet:enablePackageRestore=false'",
			"--encoding",
			"utf-8",
			"--languageserver",
		},
		filetypes = { "cs", "vb" },
		settings = {
			FormattingOptions = {
				-- Enables support for reading code style, naming convention and analyzer
				-- settings from .editorconfig.
				EnableEditorConfigSupport = true
			}
		}
	}
end

return M

