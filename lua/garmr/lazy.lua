require("lazy").setup({
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('garmr.configs.telescope')
		end
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
		config = function()
			require('garmr.configs.treesitter')
		end
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
	{
		"folke/trouble.nvim",
		-- cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require('garmr.configs.trouble')
		end
	},

	-- LSP
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			'neovim/nvim-lspconfig',
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Autocompletion
			'hrsh7th/nvim-cmp',
		},
		config = function()
			require('garmr.configs.lsp')
		end
	},
	{ 'ray-x/go.nvim' },

	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			{
				"L3MON4D3/LuaSnip",
				config = function()
					local luasnip = require("luasnip")
					luasnip.config.set_config({
						defaults = {
							history = true,
							updateevents = "TextChanged,TextChangedI",
						},
					})
				end,
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "BufEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				server_opts_overrides = {
					settings = {
						advanced = {
							listCount = 5, -- #completions for panel
							inlineSuggestCount = 3, -- #completions for getCompletions
						}
					},
				},
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		-- dependencies = {
		-- 	"hrsh7th/nvim-cmp",
		-- 	"zbirenbaum/copilot.lua",
		-- },
		config = function()
			require("copilot_cmp").setup()
		end
	},

	-- Util
	{
		"theprimeagen/refactoring.nvim",
		config = function()
			require("garmr.configs.refactoring")
		end,
	},
	{
		'mbbill/undotree',
		config = function()
			require('garmr.configs.undotree')
		end
	},
	{
		'ThePrimeagen/harpoon',
		config = function()
			require('garmr.configs.harpoon')
		end
	},
	{
		'tpope/vim-fugitive',
		config = function()
			require('garmr.configs.fugitive')
		end
	},

	-- Visual
	{ 'ray-x/guihua.lua' },
	-- { "ray-x/lsp_signature.nvim" },
	{ 'nvim-tree/nvim-web-devicons' },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install && ./install.sh",
		ft = { "markdown" },
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_browser = "firefox"
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require('garmr.configs.lualine')
		end
	},
	{
		'fei6409/log-highlight.nvim',
		config = function()
			require('log-highlight').setup {}
		end,
	},

	-- theme
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		priority = 1000,
		config = function()
			require('garmr.configs.catppuccin')
		end
	},
	-- {
	-- 	'EdenEast/nightfox.nvim',
	-- 	config = function()
	-- 		require('garmr.configs.nightfox')
	-- 	end
	-- },
})
