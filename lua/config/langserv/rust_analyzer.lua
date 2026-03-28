

local M = { name = 'rust-analyzer' }

function M.config(user_config)
	return {
		cmd = "rust-analyzer"
	}
end

return M
