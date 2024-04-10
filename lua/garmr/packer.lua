-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd.packadd('packer.nvim')

return require('packer').startup({
	function(use)
		-- Packer can manage itself
		use 'wbthomason/packer.nvim'
		use {
			'nvim-telescope/telescope.nvim', tag = '0.1.2',
			-- or                            , branch = '0.1.x',
			requires = { { 'nvim-lua/plenary.nvim' } },
			config = function()
				require('garmr.configs.telescope')
			end
		}
		use {
			"theprimeagen/refactoring.nvim",
			config = function()
				require("garmr.configs.refactoring")
			end,
		}
		use {
			'mbbill/undotree',
			config = function()
				require('garmr.configs.undotree')
			end
		}
		use {
			'ThePrimeagen/harpoon',
			config = function()
				require('garmr.configs.harpoon')
			end
		}
		use {
			'tpope/vim-fugitive',
			config = function()
				require('garmr.configs.fugitive')
			end
		}
		use {
			'catppuccin/nvim',
			as = 'catppuccin',
			config = function()
				require('garmr.configs.catppuccin')
			end
		}
		use {
			'EdenEast/nightfox.nvim',
			config = function()
				require('garmr.configs.nightfox')
			end
		}
		use {
			'nvim-treesitter/nvim-treesitter',
			run = function()
				local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
				ts_update()
			end,
			config = function()
				require('garmr.configs.treesitter')
			end
		}
		use "nvim-treesitter/nvim-treesitter-context"

		use {
			'neovim/nvim-lspconfig',
			-- requires = 'zbirenbaum/copilot.lua'
		}
		use {
			'VonHeikemen/lsp-zero.nvim',
			branch = 'v2.x',
			requires = {
				-- LSP Support
				-- { 'neovim/nvim-lspconfig' },             -- Required
				{ 'williamboman/mason.nvim' },
				{ 'williamboman/mason-lspconfig.nvim' },     -- Optional


				-- Autocompletion
				-- { 'hrsh7th/nvim-cmp' },
				-- { 'hrsh7th/cmp-buffer' },
				-- { 'hrsh7th/cmp-nvim-lsp' },
				-- { 'hrsh7th/cmp-path' },
				-- { 'hrsh7th/cmp-nvim-lua' },
				-- { 'saadparwaiz1/cmp_luasnip' },

				-- Snippets
				-- { 'L3MON4D3/LuaSnip' },
			},
			config = function()
				require('garmr.configs.lsp')
			end
		}

		-- Autocompletion
		use 'hrsh7th/nvim-cmp'
		use 'hrsh7th/cmp-buffer'
		use 'hrsh7th/cmp-path'
		use 'hrsh7th/cmp-nvim-lsp'
		use 'hrsh7th/cmp-nvim-lua'

		-- Snippets
		use {
			"L3MON4D3/LuaSnip",
			lazy = true,
			config = function()
				local luasnip = require("luasnip")
				luasnip.config.set_config({
					defaults = {
						history = true,
						updateevents = "TextChanged,TextChangedI",
					},
				})
			end,
		}

		use 'ray-x/go.nvim'
		use 'ray-x/guihua.lua'
		use "ray-x/lsp_signature.nvim"

		use {
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
					suggestion = { enabled = false },
					panel = { enabled = false },
					settings = {
						advanced = {
							listCount = 5,                 -- #completions for panel
							inlineSuggestCount = 5,        -- #completions for getCompletions
						}
					},
				})
			end,
		}
		use {
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup()
			end
		}

		use 'nvim-tree/nvim-web-devicons'
		use {
			"folke/trouble.nvim",
			require = "nvim-tree/nvim-web-devicons",
			config = function()
				require('garmr.configs.trouble')
			end
		}

		use{
			"iamcco/markdown-preview.nvim",
			run = function() vim.fn["mkdp#util#install"]() end,
		}
		use {
			'nvim-lualine/lualine.nvim',
			require = "nvim-tree/nvim-web-devicons",
			config = function()
				require('garmr.configs.lualine')
			end
		}

		-- use {
		-- 	"jeniasaigak/goplay.nvim",
		-- 	config = function()
		-- 		require("garmr.configs.goplay")
		-- 	end,
		-- }

		use {
			'fei6409/log-highlight.nvim',
			config = function()
				require('log-highlight').setup {}
			end,
		}
	end,
	config = {
		profile = {
			enable = true,
		}
	},
})
