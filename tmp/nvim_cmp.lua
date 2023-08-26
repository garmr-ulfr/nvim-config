local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'copilot' },
        {name = 'nvim_lsp'},
        {name = 'buffer'},
        {name = 'path'},
        {name = 'nvim_lua'},
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    experimental = {
            ghost_text = true,
    }
})

--set max height of items
vim.cmd([[ set pumheight=6 ]])
