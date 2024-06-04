require("trouble").setup({
	focus = true,
	modes = {
		diagnostics = {
			mode = "diagnostics",
			filter = { buf = 0 },
		}
	}
})

vim.keymap.set("n", "<leader>tt", function() require("trouble").open() end)
vim.keymap.set("n", "<leader>tw", function() require("trouble").open("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>td", function() require("trouble").open("diagnostics") end)
vim.keymap.set("n", "<leader>tq", function() require("trouble").open("quickfix") end)
vim.keymap.set("n", "<leader>tl", function() require("trouble").open("loclist") end)
