
---@meta

---@class ManagerOptions
---@field use string The name of the manager to use (lazy, packer, etc)
---@field root table The path to where packages are installed
---@field install table The path to where the manager module is installed
---@field setup table settings for package configuration


---@class LspOptions
---@field servers table<string,table> Root directory where lsp servers are installed

---@class SnippetOptions
---@field root string Root directory where snippets are installed

---@class UiOptions
---@field colors table
---@field fonts table

---@class ConfigOptions
---@field manager ManagerOptions Options for configuring the package manager
---@field snippet SnippetOptions Options for snippets
---@field ui UiOptions Options that control User Interface components
---@field lsp LspOptions Options for Lasguage Servers

---@class Manager

