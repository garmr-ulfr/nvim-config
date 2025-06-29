vim.g.mapleader = " "

local map = require("util").map

map("n", "<leader>pv", vim.cmd.Ex, { desc = "Project View" })
map("i", "<C-c>", "<Esc>")

map("v", "J", ":m '>+1<CR>gv=gv") -- move selected down
map("v", "K", ":m '<-2<CR>gv=gv") -- move selected up

map("n", "J", "mzJ`z")            -- join line
-- center jump commands
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "G", "Gzz")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "<C-o>", "<C-o>zz")

-- paste over visual selection
map("x", "<leader>p", [["_dP]])

-- copy to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

-- delete to black hole register
map({ "n", "v" }, "<leader>d", [["_d]])
map({ "n", "v" }, "<leader>c", [["_di]])

-- clear qQ mappings
map("n", "Q", "<nop>")
map("n", "q", "<nop>")

map("n", "<leader>q", "<cmd>q<CR>")        -- quit
map("n", "<leader>ff", vim.lsp.buf.format) -- format

-- map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- map("n", "<C-k>", "<cmd>cnext<CR>zz")
-- map("n", "<C-j>", "<cmd>cprev<CR>zz")
-- map("n", "<leader>k", "<cmd>lnext<CR>zz")
-- map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- long jump commands
map({ "n", "v" }, "<leader>k", "10k")
map({ "n", "v" }, "<leader>j", "10j")

-- replace all occurences of word under cursor
map("n", "<leader>wr", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- split window
map("n", "<leader>sh", "<cmd>vs<CR>", { desc = "Split horizontally" })
map("n", "<leader>sv", "<cmd>sp<CR>", { desc = "Split vertically" })

-- source file
-- map("n", "<leader><leader>", "<cmd>so<CR>")

-- auto close
map("i", [["<Tab>]], [[""<Left>]])
map("i", [['<Tab>]], [[''<Left>]])
map("i", "(<Tab>", "()<Left>")
map("i", "(<CR>", "(<CR>)<Esc>O")
map("i", "[<Tab>", "[]<Left>")
map("i", "[<CR>", "[<CR>]<Esc>O")
map("i", "{<Tab>", "{}<Left>")
map("i", "{<CR>", "{<CR>}<Esc>O")
map("i", "<<Tab>", "<><Left>")
map("i", "<<CR>", "<<CR>><Esc>O")

-- remove debug code blocks. using line comments '>>> DEBUG' marks the start of a block and '<<< DEBUG' marks the end.
map("v", "<leader>rd", [[:s/\_s\zs\_s*.\+>\{3,}\s\?DEBUG\s*\_.\{-}\n.*<\{3,}\s\?DEBUG\(\s*\n\)\+//i<CR>]],
	{ silent = true })

-- add debug code block for go. TEMPORARY, will be replaced by function to add debug code blocks for any language
map("n", "<leader>ad", "o{ ///////////// >>>>> DEBUG<CR>} ///////////// <<<<< DEBUG<CR><Esc>kO")
