
local M = {}

local M:setup()
	local wk = require('which-key')

	wk.add({
		{ mode = { 'n' }, { 'Y', 'y$', desc = 'Map Y to yank until EOL, rather than act as yy' } },
		{
			mode = { 'n', 'v', 'i' },
			{ '<C-S-y>', '"+y', desc = 'Yank to system clipboard' },
			{ '<C-S-v>', '"+p', desc = 'Paste from system clipboard' },
		},
	})
end

return M
