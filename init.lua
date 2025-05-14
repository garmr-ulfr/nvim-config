vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.lsp.config('luals', {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = {
					"lua/?.lua",
					"lua/?/init.lua"
				}
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME }
			},
		},
	},
})

vim.lsp.enable('luals')

require("config")
