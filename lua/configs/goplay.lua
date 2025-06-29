local gp = require('goplay')
gp.setup({ output_mode = 'formatted' })

vim.keymap.set('n', '<leader>ngp', function()
	local bufExist = pcall(vim.api.nvim_buf_get_name, gp._activeBuf)
	if gp._activeBuf and bufExist then
		vim.cmd.bdelete { gp._activeBuf, bang = true }
		gp._activeBuf = nil
	else
		gp.goPlaygroundOpen()
	end
end, { desc = 'Open Go Playground' })
vim.keymap.set('n', '<leader>npe', ':GPExec<CR>', { desc = 'Execute Go Playground' })
vim.keymap.set('n', '<leader>npf', ':GPExecFile<CR>', { desc = 'Execute Go Playground File' })
