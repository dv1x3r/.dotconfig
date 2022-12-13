vim.o.encoding = "utf-8"
vim.o.background = "dark"
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undodir/"

vim.o.scrolloff = 10 -- number of lines to keep visible
vim.o.sidescrolloff = 20 -- number of symbols to keep visible
vim.o.tabstop = 4 -- number of shown spaces per tab
vim.o.softtabstop = 4 -- number of pasted spaces for tab
vim.o.shiftwidth = 4 -- number of pasted spaces for >>
vim.o.expandtab = true -- replace tab with spaces
vim.o.wrap = false -- wrap to the next line

local function map(m, k, v, opts)
	opts = opts or {
			noremap = true,
			-- silent = true,
		}
	vim.keymap.set(m, k, v, opts)
end

vim.g.mapleader = ","

map("i", "jk", "<ESC>")
map("n", "<leader>nh", ":noh<CR>")

map("n", "<leader>o", "o<ESC>")
map("n", "<leader>O", "O<ESC>")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("i", "<C-e>", "<ESC>A")
map("i", "<C-a>", "<ESC>I")

map("n", "<leader>sv", "<C-w>v") -- split window vertically
map("n", "<leader>sh", "<C-w>s") -- split window horizontally
map("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
map("n", "<leader>sx", ":close<CR>") -- close current split window
-- map("n", "<leader>sm", "<C-w>_") -- maximize current split window

map("n", "<leader>to", ":tabnew<CR>") -- open new tab
map("n", "<leader>tx", ":tabclose<CR>") -- close current tab
map("n", "<leader>tn", ":tabn<CR>") --  go to next tab
map("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

map("n", "<leader>bx", ":bd!<CR>") -- force close current buffer
map("n", "<leader>bn", ":bnext<CR>") -- go to next buffer
map("n", "<leader>bp", ":bprevious<CR>") -- go to previous buffer

map("n", "<leader>vc", ":e ~/.config/nvim/init.lua <CR>")

local function ensure_packer()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand("$MYVIMRC"),
})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })
	use({ "ThePrimeagen/vim-be-good" })
	use({ "catppuccin/nvim", config = "vim.cmd [[colorscheme catppuccin]]" })
	use({ "christoomey/vim-tmux-navigator" })
	use({
		"szw/vim-maximizer",
		config = function()
			vim.keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
						},
					},
				},
				extensions = {
					file_browser = {
						-- sorting_strategy = "ascending",
						grouped = true,
						hidden = true,
					},
				},
			})
			telescope.load_extension("file_browser")
			-- https://github.com/BurntSushi/ripgrep is required for live_grep
			vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
			vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
			vim.keymap.set("n", "<leader>fs", ":Telescope current_buffer_fuzzy_find<CR>")
			vim.keymap.set("n", "<leader>fw", ":Telescope grep_string<CR>")
			vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
			vim.keymap.set("n", "<leader>fd", ":Telescope diagnostics<CR>")
			vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>")
			vim.keymap.set("n", "<leader>gc", ":Telescope git_commits<CR>")
			vim.keymap.set("n", "<leader>gbc", ":Telescope git_bcommits<CR>")
			vim.keymap.set("n", "<leader>gbr", ":Telescope git_branches<CR>")
			vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>")
		end,
	})
	use({
		"tpope/vim-dadbod",
		requires = { "kristijanhusak/vim-dadbod-ui", "kristijanhusak/vim-dadbod-completion" },
		config = function()
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui/"
			vim.keymap.set("n", "<leader>du", ":DBUIToggle<CR>")
			vim.keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>")
			vim.keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>")
			vim.keymap.set("n", "<leader>dl", ":DBUILastQueryInfo<CR>")
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "ryanoasis/vim-devicons" },
		config = function()
			require("lualine").setup({
				options = { globalstatus = true },
				sections = {
					lualine_c = {
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						},
						{
							"buffers",
						},
					},
				},
			})
		end,
	})
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({})
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({ check_ts = true })
		end,
	})
	use({ "windwp/nvim-ts-autotag", after = { "nvim-treesitter" } })
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
				auto_install = true,
				ensure_installed = {
					"css",
					"go",
					"html",
					"javascript",
					"json",
					"markdown",
					"prisma",
					"python",
					"rust",
					"sql",
					"toml",
					"typescript",
				},
			})
		end,
	})

	-- LSP, DAP, Formatters and Linters
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },

			-- Useful status updates for LSP
			{ "j-hui/fidget.nvim" },
			{ "onsails/lspkind.nvim" },

			-- Formatters and Linters
			{ "jose-elias-alvarez/null-ls.nvim" },
			{ "jayp0521/mason-null-ls.nvim" },
		},
		config = function()
			require("fidget").setup()
			local lspkind = require("lspkind")
			local lsp = require("lsp-zero")
			lsp.preset("recommended")
			lsp.nvim_workspace()
			lsp.ensure_installed({
				"tsserver",
				"eslint",
				"sumneko_lua",
				"pyright",
				"html",
				"cssls",
			})
			lsp.setup_nvim_cmp({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "vim-dadbod-completion" },
				},
				formatting = {
					format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
				},
			})
			lsp.setup()

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									filter = function(client_f)
										return client_f.name == "null-ls"
									end,
									bufnr = bufnr,
								})
							end,
						})
					end
				end,
			})
			local mason_null_ls = require("mason-null-ls")
			mason_null_ls.setup({
				ensure_installed = {
					"black",
					"prettier",
					"eslint_d",
					"stylua",
				},
			})
			mason_null_ls.setup_handlers({
				-- default server handler (if dedicated is not defined)
				function(source_name, methods)
					require("mason-null-ls.automatic_setup")(source_name, methods)
				end,
			})
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
