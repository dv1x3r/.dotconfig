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

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {'gruvbox-community/gruvbox'} --, config = 'vim.cmd [[colorscheme gruvbox]]'}
    use {'RRethy/nvim-base16', config = 'vim.cmd [[colorscheme base16-nord]]'}
    use {'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}, config = function() require('lualine').setup() end} 
  
    if packer_bootstrap then
        require('packer').sync()
    end
end)

local g = vim.g
local o = vim.o
local A = vim.api

g.mapleader = ','

o.background = 'dark'
o.encoding = 'utf-8'
o.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
o.clipboard = 'unnamedplus' -- shared clipboard
o.number = true -- line numbers
o.cursorline = true -- highlight current line

o.scrolloff = 8 -- number of lines to keep visible
o.tabstop = 4 -- number of columns per tab
o.softtabstop = 4 -- number of spaces for tab
o.shiftwidth = 4 -- number of spaces for >>
o.expandtab = true -- replace tab with spaces
o.wrap = false -- wrap to the next line

o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

local function map(m, k, v)
    vim.keymap.set(m, k, v)
end

map('n', '<leader>o', 'o<esc>')
map('n', '<leader>O', 'O<esc>')

map('i', 'jk', '<esc>')
map('i', '<c-e>', '<esc>A') -- mimic shell end of the line
map('i', '<c-a>', '<esc>I') -- mimic shell start of the line

