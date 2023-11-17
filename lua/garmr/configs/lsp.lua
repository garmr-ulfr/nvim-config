local lsp = require('lsp-zero').preset('minimal')

lsp.nvim_workspace()

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

    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>zz', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>zz', opts)
	 vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>zz', opts)
 end)

lsp.setup()

require("garmr.configs.go")
require("garmr.configs.cmp")
require("garmr.configs.lsp_signature")

vim.lsp.set_log_level("OFF")
