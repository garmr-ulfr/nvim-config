local cmp = require('cmp')
cmp.setup({
   snippet = {
       expand = function(args)
           require("luasnip").lsp_expand(args.body)
       end,
   },
    sources = {
        {name = 'copilot'},
        {name = 'nvim_lsp'},
        {name = 'path'},
        {name = 'buffer'},
        {name = 'nvim_lua'},
        {name = 'luasnip'},
    },
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    experimental = {
            ghost_text = true,
    },
})

--set max height of items
vim.cmd([[ set pumheight=6 ]])
