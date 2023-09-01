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
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    experimental = {
            ghost_text = true,
    },
--     sorting = {
--         priority_weight = 2,
--         comparators = {
--             require("copilot_cmp.comparators").prioritize,
-- 
--             -- Below is the default comparitor list and order for nvim-cmp
--             cmp.config.compare.offset,
--             -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
--             cmp.config.compare.exact,
--             cmp.config.compare.score,
--             cmp.config.compare.recently_used,
--             cmp.config.compare.locality,
--             cmp.config.compare.kind,
--             cmp.config.compare.sort_text,
--             cmp.config.compare.length,
--             cmp.config.compare.order,
--         },
--     },
--    preselect = cmp.PreselectMode.Item,
})

--set max height of items
vim.cmd([[ set pumheight=6 ]])
