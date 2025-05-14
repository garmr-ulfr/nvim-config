require('telescope').setup({
    defaults = {
        file_ignore_patterns = {
            "%.git",
            "node_modules/.*",
            "dist/.*",
        },
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
vim.keymap.set('n', '<leader>bs', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

