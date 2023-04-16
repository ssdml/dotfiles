-- [[ Basic Keymaps ]]

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- Resource init.vim
vim.keymap.set('n', '<leader>sou', ':source $HOME/.config/nvim/init.lua | silent! LspStop | silent! LspStart | PackerCompile <CR>')


-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })


-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- Exit visual mode
vim.keymap.set('i', 'jj', '<Esc>')


-- Prev, next buffers
vim.keymap.set('n', 'H', ':bp<CR>')
vim.keymap.set('n', 'L', ':bn<CR>')


-- Go to left, down, up, right window
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')


-- Copy all text to clipboard
vim.keymap.set('n', '<leader>a', ':%y+<CR>')

-- Copy to system clipboard
vim.keymap.set('n', '<leader>c', '"+y')
vim.keymap.set('x', '<leader>c', '"+y')

-- Past from system clipboard
vim.keymap.set('n', '<leader>v', '"+p')
vim.keymap.set('n', '<leader>V', '"+P')

-- Past without replacing default register
vim.keymap.set('x', '<silent> <leader>p', 'p:let @--=@0<CR>')

-- Shortcut for replacing
vim.keymap.set('n', '<leader>rr', ':%s//g<left><left>')

-- Shortcut for replacing selected text.
-- Copy selected to "r" - register, then past it into replacement command.
vim.keymap.set('x', '<leader>rr', '"ry:%s/<C-r>r//g<left><left>')

-- Put date
vim.keymap.set('n', '<leader>pd', ":put =strftime('%d.%m.%Y')<CR>")

-- Put time
vim.keymap.set('n', '<leader>pt', ":put =strftime('%H:%M:%S')<CR>")

-- 'alt+h' and 'alt+l' go to first and last symbol in the line
vim.keymap.set('n', '<A-h>', '^')
vim.keymap.set('n', '<A-l>', '$')
vim.keymap.set('v', '<A-h>','^')
vim.keymap.set('v', '<A-l>','$')

-- Mapping alt+k, alt+j alt+m to got to the top, bottom and middle of the screen
vim.keymap.set('n', '<A-k>', 'H')
vim.keymap.set('n', '<A-j>', 'L')
vim.keymap.set('n', '<A-m>', 'M')
