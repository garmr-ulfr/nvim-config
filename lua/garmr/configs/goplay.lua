local gp = require('goplay')
gp.setup({output_mode = 'formatted'})

vim.keymap.set('n', '<leader>gop', function ()
	local bufExist = pcall(vim.api.nvim_buf_get_name, gp._activeBuf)
	if gp._activeBuf and bufExist then
		vim.cmd.bdelete{gp._activeBuf, bang = true}
		gp._activeBuf = nil
	else
		gp.goPlaygroundOpen()
	end
end)
vim.keymap.set('n', '<leader>goe', ':GPExec<CR>')
vim.keymap.set('n', '<leader>gof', ':GPExecFile<CR>')
