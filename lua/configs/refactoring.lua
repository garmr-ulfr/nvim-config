require("refactoring").setup({
	prompt_func_return_type = {
		go = true,
	},
	prompt_func_param_type = {
		go = true,
	},
})
vim.keymap.set("x", "<leader>re", ":Refactor extract ", {noremap = true})
vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", {noremap = true})
vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", {noremap = true})

vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", {noremap = true})
vim.keymap.set( "n", "<leader>rI", ":Refactor inline_func", {noremap = true})
