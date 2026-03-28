
---@meta

-- #region config.option objects -------------------------------------------------------

---@class ManagerOptions
---@field public use string The name of the manager to use (lazy, packer, etc)
---@field public install table The path to where the manager module is installed
---@field public target string The path to where packages are installed
---@field public source table The list of packages that the manager will install/configure
---@field public setup table settings for package configuration

---@class SnippetOptions
---@field public root string Root directory where snippets are installed

---@class UiOptions
---@field public colors table A table of color options
---@field public fonts table A table of fonts to be used

---@class ShellOptions
---@field public pwsh table Powershell options
---@field public python table Python options

---@class ConfigOptions
---@field public shell ShellOptions Options for shells
---@field public snippets SnippetOptions Options for snippets
---@field public ui UiOptions Options that control User Interface components

-- #endregion config.option objects ---------------------------------------------------

-- #region config objects -------------------------------------------------------------
---@class Manager
---@field public name string Name used to identify the manager type
---@field private options ManagerOptions The configuration options needed by Manager

---@class LazyManager : Manager
---@class LangServManager : Manager

---@class NVimConfig
---@field public name string A unique name for the class.
---@field public path string The path to the given class file
---@field public stages string[] List of stages to apply
---@field public options ConfigOptions Settings that control the configuration
-- #endregion config objects ----------------------------------------------------------
