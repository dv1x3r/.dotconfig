local function ensure_packer()
    local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Visual
    use {'gruvbox-community/gruvbox'} --, config = 'vim.cmd [[colorscheme gruvbox]]'}
    use {'RRethy/nvim-base16', config = 'vim.cmd [[colorscheme base16-nord]]'}
    use {'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}, config = function() require('lualine').setup() end} 

    -- Database
    use {'tpope/vim-dadbod'}
    use {'kristijanhusak/vim-dadbod-ui', config = function() vim.g.db_ui_save_location = vim.fn.stdpath('data')..'/db_ui/' end}

    -- Fun
    use 'ThePrimeagen/vim-be-good'
  
    if packer_bootstrap then
        require('packer').sync()
    end
end)

local o = vim.o

o.background = 'dark'
o.encoding = 'utf-8'
o.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
o.clipboard = 'unnamedplus' -- shared clipboard
o.number = true -- line numbers
o.relativenumber = true -- relative line numbers
o.cursorline = true -- highlight current line
o.signcolumn = 'yes' -- column on the left side of line numbers

o.swapfile = false
o.backup = false
o.undofile = true
o.undodir = vim.fn.stdpath('data')..'/undodir/'

o.scrolloff = 8 -- number of lines to keep visible
o.tabstop = 4 -- number of columns per tab
o.softtabstop = 4 -- number of spaces for tab
o.shiftwidth = 4 -- number of spaces for >>
o.expandtab = true -- replace tab with spaces
o.wrap = false -- wrap to the next line

o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = false

local function map(m, k, v, opts)
    opts = opts or { noremap = true }
    vim.keymap.set(m, k, v, opts)
end

vim.g.mapleader = ','

map('n', '<leader>o', 'o<esc>')
map('n', '<leader>O', 'O<esc>')

map('i', 'jk', '<esc>')
map('i', '<c-e>', '<esc>A') -- mimic shell end of the line
map('i', '<c-a>', '<esc>I') -- mimic shell start of the line

map('n', '<leader>du', '<cmd>DBUIToggle<cr>')
map('n', '<leader>df', '<cmd>DBUIFindBuffer<cr>')
map('n', '<leader>dr', '<cmd>DBUIRenameBuffer<cr>')
map('n', '<leader>dl', '<cmd>DBUILastQueryInfo<cr>')

