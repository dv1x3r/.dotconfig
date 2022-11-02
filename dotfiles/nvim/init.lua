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
    use 'ThePrimeagen/vim-be-good'
    use {'gruvbox-community/gruvbox'} --, config = 'vim.cmd [[colorscheme gruvbox]]' }
    use {'RRethy/nvim-base16', config = 'vim.cmd [[colorscheme base16-nord]]'}
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function() require('lualine').setup() end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-file-browser.nvim'},
        config = function()
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')
            telescope.setup({
                pickers = {
                    buffers = {
                        mappings = {
                            n = {
                                ['dd'] = 'delete_buffer'
                            }
                        }
                    }
                },
                extensions = {
                    file_browser = {
                        sorting_strategy = 'ascending',
                        grouped = true,
                        hidden = true
                    }
                }
            })
            telescope.load_extension('file_browser')
            vim.keymap.set('n', '<leader>ff', builtin.find_files)
            vim.keymap.set('n', '<leader>fg', builtin.live_grep)
            vim.keymap.set('n', '<leader>fb', builtin.buffers)
            vim.keymap.set('n', '<leader>fh', builtin.help_tags)
            vim.keymap.set('n', '<leader>e', ':Telescope file_browser<CR>')
        end
    }
    use {
        'TimUntersberger/neogit',
        requires = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim'
        },
        config = function()
            local neogit = require('neogit')
            neogit.setup({ integrations = { diffview = true } })
            vim.keymap.set('n', '<leader>gs', function() neogit.open() end)
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup() end
    }
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }
    use {
        'kylechui/nvim-surround',
        config = function() require('nvim-surround').setup() end
    }
    use {
        'rcarriga/nvim-dap-ui',
        requires = {'mfussenegger/nvim-dap'},
        config = function() require('dapui').setup() end
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

    if packer_bootstrap then
        require('packer').sync()
    end
end)

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.encoding = 'utf-8'
vim.o.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true -- highlight current line
vim.o.signcolumn = 'yes' -- column on the left side of line numbers
vim.o.clipboard = 'unnamedplus' -- shared clipboard

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('data')..'/undodir/'

vim.o.scrolloff = 10 -- number of lines to keep visible
vim.o.tabstop = 4 -- number of columns per tab
vim.o.softtabstop = 4 -- number of spaces for tab
vim.o.shiftwidth = 4 -- number of spaces for >>
vim.o.expandtab = true -- replace tab with spaces
vim.o.wrap = false -- wrap to the next line

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

vim.g.mapleader = ','

local function map(m, k, v, opts)
    opts = opts or { noremap = true }
    vim.keymap.set(m, k, v, opts)
end

map('i', 'jk', '<ESC>')

map('n', '<leader>o', 'o<ESC>')
map('n', '<leader>O', 'O<ESC>')

map('i', '<C-e>', '<ESC>A')
map('i', '<C-a>', '<ESC>I')

