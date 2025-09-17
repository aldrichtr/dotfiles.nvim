

local util = require('util')
local mngr = require('manager.lazy'):new()

local std = {
  data = vim.fn.stdpath('data'),
  config = vim.fn.stdpath('config')
}

vim.g.mapleader = " "
vim.g.maplocalleader = ","

mngr:load()
