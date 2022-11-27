vim.o.encoding = "utf-8"
vim.o.background = "dark"
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"

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
	opts = opts or { noremap = true }
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
map("n", "<leader>sm", "<C-w>_") -- maximize current split window
map("n", "<leader>sx", ":close<CR>") -- close current split window

map("n", "<leader>to", ":tabnew<CR>") -- open new tab
map("n", "<leader>tx", ":tabclose<CR>") -- close current tab
map("n", "<leader>tn", ":tabn<CR>") --  go to next tab
map("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

map("n", "<leader>bx", ":bd!<CR>") -- force close current buffer
map("n", "<leader>bn", ":bnext<CR>") -- go to next buffer
map("n", "<leader>bp", ":bprevious<CR>") -- go to previous buffer

vim.cmd(":command! Config e ~/.config/nvim/init.lua")

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

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })
	use({ "ThePrimeagen/vim-be-good" })
	use({ "christoomey/vim-tmux-navigator" })
	use({ "catppuccin/nvim", config = "vim.cmd [[colorscheme catppuccin]]" })

	-- Visualization
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
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
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
				ensure_installed = {
					"bash",
					"c_sharp",
					"css",
					"html",
					"javascript",
					"json",
					"lua",
					"make",
					"markdown",
					"prisma",
					"python",
					"rust",
					"sql",
					"toml",
					"tsx",
					"typescript",
				},
				auto_install = true,
			})
		end,
	})

	-- LSP, DAP, linters and formatters
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})
	use({
		"L3MON4D3/LuaSnip",
		requires = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	})
	use({
		"williamboman/mason.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jayp0521/mason-null-ls.nvim",
		},
		config = function()
			require("mason").setup({})
			local lspconfig = require("lspconfig")
			local lsp_defaults = lspconfig.util.default_config
			lsp_defaults.capabilities =
				vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = {
					"pyright",
					"rust_analyzer",
					"sumneko_lua",
					"tsserver",
					"html",
					"cssls",
				},
			})
			mason_lspconfig.setup_handlers({
				-- default server handler (if dedicated is not defined)
				function(server)
					lspconfig[server].setup({})
				end,
				-- dedicated server handlers
				sumneko_lua = function(_)
					require("lspconfig").sumneko_lua.setup({
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				end,
			})

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
					"autopep8",
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
				-- dedicated server handlers
				-- autopep8 = function(source_name, methods)
				-- 	null_ls.register(null_ls.builtins.formatting.autopep8)
				-- end,
			})
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
			"windwp/nvim-autopairs",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				-- completion = { autocomplete = false },
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vim-dadbod-completion" },
					{ name = "luasnip", keyword_length = 2 },
				}),
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			vim.o.completeopt = "menu,menuone,noselect"
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function()
					local bufmap = function(mode, lhs, rhs)
						vim.keymap.set(mode, lhs, rhs, { buffer = true })
					end
					bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>") -- Displays hover information about the symbol under the cursor
					bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>") -- Jump to the definition
					bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>") -- Jump to declaration
					bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>") -- Lists all the implementations for the symbol under the cursor
					bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>") -- Jumps to the definition of the type symbol
					bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>") -- Lists all the references
					bufmap("n", "ghs", "<cmd>lua vim.lsp.buf.signature_help()<cr>") -- Displays a function's signature information
					bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>") -- Renames all references to the symbol under the cursor
					bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>") -- Selects a code action available at the current cursor position
					bufmap("x", "<F4>", "<cmd>lua vim.lsp.buf.range_code_action()<cr>") -- Selects a code action available at the current cursor position
					bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>") -- Show diagnostics in a floating window
					bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>") -- Move to the previous diagnostic
					bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>") -- Move to the next diagnostic
				end,
			})
		end,
	})

	-- Debugging
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup()
		end,
		enable = false,
	})

	-- Tools
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
				pickers = {
					buffers = {
						mappings = {
							n = {
								["dd"] = actions.delete_buffer,
							},
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
			vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
			vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
			vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>")
			vim.keymap.set("n", "<leader>gc", ":Telescope git_commits<CR>")
			vim.keymap.set("n", "<leader>gfc", ":Telescope git_bcommits<CR>")
			vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>")
			vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>")
		end,
	})

	-- Databases
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = { "tpope/vim-dadbod" },
		config = function()
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui/"
			vim.keymap.set("n", "<leader>du", ":DBUIToggle<CR>")
			vim.keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>")
			vim.keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>")
			vim.keymap.set("n", "<leader>dl", ":DBUILastQueryInfo<CR>")
		end,
	})
	use({
		"kristijanhusak/vim-dadbod-completion",
		commit = "01c4f7a66786095c6f00f877c616eaf34c425a06",
		requires = { "tpope/vim-dadbod" },
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
