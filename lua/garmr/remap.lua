vim.g.mapleader = " "

local map = function(mode, lhs, rhs, opts)
    local op = opts or {}
    vim.keymap.set(mode, lhs, rhs, op)
end

map("n", "<leader>pv", vim.cmd.Ex)
map("i", "<C-c>", "<Esc>")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "G", "Gzz")

map("x", "<leader>p", [["_dP]])

map({"n", "v"}, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map({"n", "v"}, "<leader>d", [["_d]])
map({"n", "v"}, "<leader>c", [["_di]])

map("n", "Q", "<nop>")
map("n", "q", "<nop>")
-- map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>ff", vim.lsp.buf.format)

-- map("n", "<C-k>", "<cmd>cnext<CR>zz")
-- map("n", "<C-j>", "<cmd>cprev<CR>zz")
-- map("n", "<leader>k", "<cmd>lnext<CR>zz")
-- map("n", "<leader>j", "<cmd>lprev<CR>zz")

map({"n", "v"}, "<leader>k", "10k")
map({"n", "v"}, "<leader>j", "10j")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

map("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/garmr/packer.lua<CR>");

map("n", "<leader>sh", function()
    vim.cmd("sp")
end)

map("n", "<leader>sv", function()
    vim.cmd("vs")
end)

map("n", "<leader><leader>", function()
    vim.cmd("so")
end)

map("i", '"<Tab>', '""<Left>')
map("i", "'<Tab>", "''<Left>")
map("i", "(<Tab>", "()<Left>")
map("i", "(<CR>", "(<CR>)<Esc>O")
map("i", "[<Tab>", "[]<Left>")
map("i", "[<CR>", "[<CR>]<Esc>O")
map("i", "{<Tab>", "{}<Left>")
map("i", "{<CR>", "{<CR>}<Esc>O")
map("i", "<<Tab>", "<><Left>")
map("i", "<<CR>", "<<CR>><Esc>O")

map("n", "<leader>vh", "<C-w>h")
map("n", "<leader>vl", "<C-w>l")
map("n", "<leader>vj", "<C-w>j")
map("n", "<leader>vk", "<C-w>k")
