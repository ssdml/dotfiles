" Resource init.vim
nmap <leader>sou :source $HOME/.config/nvim/init.vim<CR>

" Exit visual mode
imap jj <Esc>

" Prev, next buffers
nmap <A-h> :bp<CR>
nmap <A-l> :bn<CR>

" Go to left, down, up, right window
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Copy all text to clipboard
nmap <leader>a :%y+<CR>

" Copy to system clipboard
nmap <leader>c "+y
xmap <leader>c "+y

" Past from system clipboard
nmap <leader>v "+p
nmap <leader>V "+P

" Past without replacing default register
xnoremap <silent> <leader>p p:let @"=@0<CR>

" Shortcut for replacing
nmap <leader>rr :%s//g<left><left>

" Shortcut for replacing selected text.
" Copy selected to "r" - register, then past it into replacement command.
xmap <leader>rr "ry:%s/<C-r>r//g<left><left>

" Put date
nmap <leader>pd :put =strftime('%d.%m.%Y')<CR>

" Put time
nmap <leader>pt :put =strftime('%H:%M:%S')<CR>

" 'H' and 'L' go to first and last symbol in the line
nnoremap H ^
nnoremap L $

" 'cH' and 'cL' change till first, change till last
nnoremap cH c^
nnoremap cL c$

" 'dH' and 'dL' delete till first, delete till last
nnoremap dH d^
nnoremap dL d$

" Mapping alt+k, alt+j alt+m to H, L, M
nnoremap <A-k> H
nnoremap <A-j> L
nnoremap <A-m> M
