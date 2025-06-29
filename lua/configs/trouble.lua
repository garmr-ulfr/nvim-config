require("trouble").setup({
	focus = true,
	keys = {
		["<cr>"] = "jump_close",
	},
	-- modes = {
	-- 	diagnostics = {
	-- 		mode = "diagnostics",
	-- 		filter = { buf = 0 },
	-- 	}
	-- }
})

vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>tp", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Project diagnostics" })
