local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- https://github.com/wbthomason/packer.nvim
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {'gruvbox-community/gruvbox', cmd = 'colorscheme gruvbox'}
  
  if packer_bootstrap then
    require('packer').sync()
  end
end)

local o = vim.o
o.encoding = "utf-8"
o.langmap="ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
o.number = true -- line numbers
o.scrolloff = 8 -- number of lines to keep visible
o.clipboard = 'unnamedplus' -- shared clipboard

o.tabstop = 4 -- number of columns per tab
o.softtabstop = 4 -- number of spaces for tab
o.shiftwidth = 4 -- number of spaces for >>
o.expandtab = true -- replace tab with spaces
o.wrap = false

o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })

