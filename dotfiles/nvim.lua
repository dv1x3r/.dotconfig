vim.o.encoding = 'utf-8'
vim.o.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
vim.o.background = 'dark'
vim.o.termguicolors = true

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
vim.o.tabstop = 4 -- number of shown spaces per tab
vim.o.softtabstop = 4 -- number of pasted spaces for tab
vim.o.shiftwidth = 4 -- number of pasted spaces for >>
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
map('n', '<leader>nh', ':noh<CR>')

map('n', '<leader>o', 'o<ESC>')
map('n', '<leader>O', 'O<ESC>')

map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

map('i', '<C-e>', '<ESC>A')
map('i', '<C-a>', '<ESC>I')

map('n', '<leader>sv', '<C-w>v') -- split window vertically
map('n', '<leader>sh', '<C-w>s') -- split window horizontally
map('n', '<leader>se', '<C-w>=') -- make split windows equal width & height
map('n', '<leader>sx', ':close<CR>') -- close current split window

map('n', '<leader>to', ':tabnew<CR>') -- open new tab
map('n', '<leader>tx', ':tabclose<CR>') -- close current tab
map('n', '<leader>tn', ':tabn<CR>') --  go to next tab
map('n', '<leader>tp', ':tabp<CR>') --  go to previous tab

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
    use 'christoomey/vim-tmux-navigator'
    use {'szw/vim-maximizer', config = function() vim.keymap.set('n', '<leader>sm', ':MaximizerToggle<CR>') end}
    use {'RRethy/nvim-base16', config = 'vim.cmd [[colorscheme base16-nord]]'}
    use {'gruvbox-community/gruvbox'} --, config = 'vim.cmd [[colorscheme gruvbox]]'}
    use {'nvim-lualine/lualine.nvim', requires = {'ryanoasis/vim-devicons'}, config = function() require('lualine').setup() end}
    use {'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end}
    use {'numToStr/Comment.nvim', config = function() require('Comment').setup() end}
    use {'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end}
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
            vim.keymap.set('n', '<leader>du', ':DBUIToggle<CR>')
            vim.keymap.set('n', '<leader>df', ':DBUIFindBuffer<CR>')
            vim.keymap.set('n', '<leader>dr', ':DBUIRenameBuffer<CR>')
            vim.keymap.set('n', '<leader>dl', ':DBUILastQueryInfo<CR>')
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-file-browser.nvim'},
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            telescope.load_extension('file_browser')
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ['<C-k>'] = actions.move_selection_previous, -- move to prev result
                            ['<C-j>'] = actions.move_selection_next, -- move to next result
                            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                        },
                    },
                },
                pickers = {
                    buffers = {
                        mappings = {
                            n = {
                                ['dd'] = actions.delete_buffer,
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
            -- https://github.com/BurntSushi/ripgrep is required for live_grep
            vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
            vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')
            vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>')
            vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>')
            vim.keymap.set('n', '<leader>fe', ':Telescope file_browser<CR>')
            vim.keymap.set('n', '<leader>gc', ':Telescope git_commits<CR>')
            vim.keymap.set('n', '<leader>gfc', ':Telescope git_bcommits<CR>')
            vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>')
            vim.keymap.set('n', '<leader>gs', ':Telescope git_status<CR>')
        end
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets'},
        config = function()
            vim.o.completeopt = 'menu,menuone,noselect'
            require("luasnip.loaders.from_vscode").lazy_load()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            cmp.setup({
                completion = {
                    autocomplete = false
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
                    ['<C-e>'] = cmp.mapping.abort(), -- close completion window
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    -- { name = 'nvim_lsp' }, -- lsp
                    { name = 'luasnip' }, -- snippets
                    { name = 'buffer' }, -- text within current buffer
                    { name = 'path' }, -- file system paths
                }),
                -- configure lspkind for vs-code like icons
                -- formatting = {
                --     format = lspkind.cmp_format({
                --         maxwidth = 50,
                --         ellipsis_char = '...',
                --     }),
                -- },
            })
        end
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

