call plug#begin()

" Color schema gruvbox
Plug 'morhetz/gruvbox'

" Bottom status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File exporer
Plug 'preservim/nerdtree'

" Icons for nerdtree
" Plug 'ryanoasis/vim-devicons'

" Show tags
Plug 'majutsushi/tagbar'

" Fuzzy finding features
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Automatically clear highlight after cursor moved and some other autocmd event
Plug 'haya14busa/is.vim'

" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Comment lines
Plug 'preservim/nerdcommenter'

" tsx highlight support
Plug 'tasn/vim-tsx'

" VimWiki
Plug 'vimwiki/vimwiki'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Tasks
Plug 'crispydrone/vim-tasks'


call plug#end()
