require("lazy").setup({
	-- theme
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		priority = 1000,
		config = function()
			require('configs.catppuccin')
		end
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			-- triggers = {},
			spec = {
				{ "<leader>f", group = "file" },
				{ "<leader>g", group = "git" },
				{ "<leader>p", group = "project" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ import = "plugins" },
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
		"zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		event = "BufEnter",
		opts = {
			copilot_model = "gpt-4.1",
			suggestion = { enabled = false }, -- disable inline suggestions
			panel = { enabled = false }, -- disable the copilot panel
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		lazy = true,
		opts = {},
	},
	-- {
	-- 	'huggingface/llm.nvim',
	-- 	config = function()
	-- 		require('configs.llm_ls')
	-- 	end
	-- },

	-- Util
	{
		'mbbill/undotree',
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Undotree", mode = "n" }
		}
	},
	{
		'tpope/vim-fugitive',
		keys = {
			{ "<leader>gs", vim.cmd.Git,         desc = "Git status" },
			{ "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
		},
	},
	{ 'numToStr/Comment.nvim' },
	-- Visual
	{ 'nvim-tree/nvim-web-devicons', lazy = true },
	{
		'nvim-treesitter/playground',
		cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		optional = true,
		opts = {
			file_types = { "markdown", "copilot-chat" },
		},
		ft = { "markdown", "copilot-chat", "codecompanion" },
	},
	{ 'fei6409/log-highlight.nvim', ft = { "log" } },

	-- {
	-- 	'EdenEast/nightfox.nvim',
	-- 	config = function()
	-- 		require('configs.nightfox')
	-- 	end
	-- },
})
