local lsp = require('lsp-zero').preset({})

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

	vim.keymap.set('n', 'gD', function()
		vim.lsp.buf.declaration()
		vim.cmd.normal('zz')
	end, opts)
	vim.keymap.set('n', 'gd', function()
		vim.lsp.buf.definition()
		vim.cmd.normal('zz')
	end, opts)
	vim.keymap.set('n', 'go', function()
		vim.lsp.buf.type_definition()
		vim.cmd.normal('zz')
	end, opts)
end)

lsp.set_sign_icons({
	sign_icons = {
		error = 'E',
		warn = 'W',
		hint = 'H',
		info = 'I',
	}
})

require("garmr.configs.go")

lsp.setup()

require("garmr.configs.cmp")

-- vim.lsp.set_log_level("OFF")
-- vim.cmd("MasonUpdate")
