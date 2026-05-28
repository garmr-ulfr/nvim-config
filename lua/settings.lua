vim.g.editorconfig = false
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.showmode = false
vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"
vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99

vim.opt.mouse = ""
-- vim.g.clipboard = 'osc52'

-- Block writes to files named \ ' or ], which otherwise get created by
-- fat-fingering one of those keys right after `:w` (`:w\` writes file "\").
-- The doubled backslash escapes \ in the autocmd pattern.
vim.api.nvim_create_autocmd("BufWriteCmd", {
	pattern = { "\\\\", "'", "]" },
	callback = function(args)
		vim.api.nvim_echo(
			{ { "refusing to write file named '" .. args.file .. "' (likely a typo)", "ErrorMsg" } },
			true,
			{ err = true }
		)
	end,
})
