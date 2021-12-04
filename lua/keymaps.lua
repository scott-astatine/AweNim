local keymap = vim.api.nvim_set_keymap
vim.g.mapleader = ' '

local ops = {noremap = true, silent = true}

--- Window Navigation
keymap('n', '<C-l>', '<C-w>l', ops)
keymap('n', '<C-h>', '<C-w>h', ops)
keymap('n', '<C-j>', '<C-w>j', ops)
keymap('n', '<C-k>', '<C-w>k', ops)

-- Search
keymap('n', '/', ':lua require("searchbox").incsearch()<CR>', ops)
keymap('v', '/', '<Esc><cmd>lua require("searchbox").incsearch({visual_mode = true})<CR>', ops)

-- Buffer Navigation
keymap('n', 'L', ':bn!<CR>', ops)
keymap('n', 'H', ':bp!<CR>', ops)
keymap('n', '<Leader>x', ':', ops)

-- Completion & Lsp
keymap('i', '<expr><TAB>', 'pumvisible() ? \"\\<C-n>\" : \\"<TAB>\"', ops)
keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', ops)
keymap('n', 'R', ':lua vim.lsp.buf.rename()<CR>', ops)


-- Tab indent
keymap('n', '<', '<gv', ops)
keymap('n', '>', '>gv', ops)
keymap('v', '<', '<gv', ops)
keymap('v', '>', '>gv', ops)
keymap('x', '<', '<gv', ops)
keymap('x', '>', '>gv', ops)

-- Escapes
keymap('i', 'jk', '<ESC>', ops)
keymap('i', 'kj', '<ESC>', ops)
keymap('i', 'jj', '<ESC>', ops)

-- Smooth Scorlling
local t = {}
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '250'}}
t['<C-d>'] = {'scroll', {'vim.wo.scroll', 'true', '250'}}
t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '450'}}
t['<C-f>'] = {'scroll', {'vim.api.nvim_win_get_height(0)', 'true', '450'}}
t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
t['<C-e>'] = {'scroll', {'0.10', 'false', '100'}}
t['zt'] = {'zt', {'250'}}
t['zz'] = {'zz', {'250'}}
t['zb'] = {'zb', {'250'}}

require('neoscroll.config').set_mappings(t)

