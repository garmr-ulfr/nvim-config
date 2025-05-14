require("lazy").setup({
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('configs.telescope')
		end
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{
		'nvim-treesitter/nvim-treesitter',
		build = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
		config = function()
			require('configs.treesitter')
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require('configs.trouble')
		end
	},
	{ 'mason-org/mason.nvim' },
	{ 'mason-org/mason-lspconfig.nvim' },
	{
		'neovim/nvim-lspconfig',
		config = function()
			require('configs.lsp_config')
		end
	},
	{ 'ray-x/go.nvim' },
	--  {
	--   "saghen/blink.cmp",
	--   opts = {
	--     sources = {
	--       -- add lazydev to your completion providers
	--       default = { "lazydev", "lsp", "path", "snippets", "buffer" },
	--       providers = {
	--         lazydev = {
	--           name = "LazyDev",
	--           module = "lazydev.integrations.blink",
	--           -- make lazydev completions top priority (see `:h blink.cmp`)
	--           score_offset = 100,
	--         },
	--       },
	--     },
	--   },
	-- },
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
		config = function()
			require('configs.nvim_cmp')
		end
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "BufEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end
	},
	{ import = "plugins" },
	-- {
	-- 	'huggingface/llm.nvim',
	-- 	config = function()
	-- 		require('configs.llm_ls')
	-- 	end
	-- },

	-- Util
	{
		"theprimeagen/refactoring.nvim",
		config = function()
			require("configs.refactoring")
		end,
	},
	{
		'mbbill/undotree',
		config = function()
			require('configs.undotree')
		end
	},
	{
		'ThePrimeagen/harpoon',
		config = function()
			require('configs.harpoon')
		end
	},
	{
		'tpope/vim-fugitive',
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
			vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>")
		end
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},
	{
		'jeniasaigak/goplay.nvim',
		config = function()
			require('goplay').setup()
			vim.api.nvim_set_keymap('n', '<leader>gop', ':GPToggle<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gpe', ':GPExec<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gpf', ':GPExecFile<CR>', { noremap = true, silent = true })
		end
	},

	-- Visual
	{ 'ray-x/guihua.lua' },
	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require('configs.lsp_signature')
		end
	},
	{ 'nvim-tree/nvim-web-devicons' },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		optional = true,
		opts = {
			file_types = { "markdown", "copilot-chat" },
		},
		ft = { "markdown", "copilot-chat" },
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require('configs.lualine')
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
			require('configs.catppuccin')
		end
	},
	-- {
	-- 	'EdenEast/nightfox.nvim',
	-- 	config = function()
	-- 		require('configs.nightfox')
	-- 	end
	-- },
})
