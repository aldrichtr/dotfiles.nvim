
local path = require('util.path')

local M = {
    pwsh = path.join(path.Programs, "WindowsApps", "Microsoft.PowerShell_7.5.3.0_x64__8wekyb3d8bbwe", "pwsh.exe"),
    python = path.join(path.Programs, "Python312", "python.exe")
}

return M

