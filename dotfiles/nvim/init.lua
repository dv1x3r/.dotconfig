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
    use 'ThePrimeagen/vim-be-good' -- :VimBeGood - training games
    use {'RRethy/nvim-base16', config = 'vim.cmd [[colorscheme base16-nord]]'}
    use {'gruvbox-community/gruvbox'} --, config = 'vim.cmd [[colorscheme gruvbox]]' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function() require('lualine').setup() end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end
    }
    use {
        'numToStr/Comment.nvim', -- gcc commenting code
        config = function() require('Comment').setup() end
    }
    use {
        'TimUntersberger/neogit',
        requires = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim'
        },
        config = function() require('neogit').setup({integrations = {diffview = true}}) end
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup() end
    }
    use {
        'kristijanhusak/vim-dadbod-ui',
        requires = {'tpope/vim-dadbod'},
        config = function()
            vim.g.db_ui_save_location = vim.fn.stdpath('data')..'/db_ui/'
            vim.keymap.set('n', '<leader>du', '<cmd>DBUIToggle<cr>')
            vim.keymap.set('n', '<leader>df', '<cmd>DBUIFindBuffer<cr>')
            vim.keymap.set('n', '<leader>dr', '<cmd>DBUIRenameBuffer<cr>')
            vim.keymap.set('n', '<leader>dl', '<cmd>DBUILastQueryInfo<cr>')
        end
    }
    use {
        'rcarriga/nvim-dap-ui',
        requires = {'mfussenegger/nvim-dap'},
        config = function() require('dapui').setup() end
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

local o = vim.o

o.termguicolors = true
o.background = 'dark'
o.encoding = 'utf-8'
o.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

o.clipboard = 'unnamedplus' -- shared clipboard
o.number = true
o.relativenumber = true
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
o.hlsearch = true

local function map(m, k, v, opts)
    opts = opts or { noremap = true }
    vim.keymap.set(m, k, v, opts)
end

vim.g.mapleader = ','

map('n', '<leader>o', 'o<esc>')
map('n', '<leader>O', 'O<esc>')

map('i', '<c-e>', '<esc>A')
map('i', '<c-a>', '<esc>I')

