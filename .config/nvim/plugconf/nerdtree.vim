let NERDTreeQuitOnOpen=1

nnoremap <expr> <leader>e g:NERDTree.IsOpen() ? ':NERDTreeClose<cr>' : ':NERDTreeFind<cr>'
nnoremap <expr> <leader>E g:NERDTree.IsOpen() ? ':NERDTreeClose<cr>' : ':NERDTreeVCS<cr>'
