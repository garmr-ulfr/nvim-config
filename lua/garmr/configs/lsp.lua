local lsp = require('lsp-zero').preset('recommended')

lsp.ensure_installed({
	'gopls',
--	'lua-language-server',
})

-- lsp.nvim_workspace()

lsp.set_preferences({
    suggest_lsp_server = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I',
    }
})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
end)

lsp.setup()

require("garmr.configs.go")
require("garmr.configs.cmp")
require("garmr.configs.lsp_signature")

