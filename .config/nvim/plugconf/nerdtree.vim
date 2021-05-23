let NERDTreeQuitOnOpen=1

nnoremap <expr> <leader>e g:NERDTree.IsOpen() ? ':NERDTreeClose<cr>' : ':NERDTreeFind<cr>'
nnoremap <expr> <leader>E g:NERDTree.IsOpen() ? ':NERDTreeClose<cr>' : ':NERDTreeVCS<cr>'

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

function! NERDTreeAddDataMdFile()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let newNodeName = curDirNode.path.str() . nerdtree#slash() . strftime('%Y-%m-%d') . '.md'

    try
        let newPath = g:NERDTreePath.Create(newNodeName)
        let parentNode = b:NERDTree.root.findNode(newPath.getParent())

        let newTreeNode = g:NERDTreeFileNode.New(newPath, b:NERDTree)
        " Emptying g:NERDTreeOldSortOrder forces the sort to
        " recalculate the cached sortKey so nodes sort correctly.
        let g:NERDTreeOldSortOrder = []
        if empty(parentNode)
            call b:NERDTree.root.refresh()
            call b:NERDTree.render()
        elseif parentNode.isOpen || !empty(parentNode.children)
            call parentNode.addChild(newTreeNode, 1)
            call NERDTreeRender()
            call newTreeNode.putCursorHere(1, 0)
        endif

        redraw!
    catch /^NERDTree/
        call nerdtree#echoWarning('Node Not Created.')
    endtry
endfunction

call NERDTreeAddMenuItem({'text': '(z) create md file with date', 'shortcut': 'z', 'callback': 'NERDTreeAddDataMdFile'})
