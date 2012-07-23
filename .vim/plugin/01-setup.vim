" Make sure system defaults are consistent
" ===

" Intuitive backspacing in insert mode
set backspace=indent,eol,start

" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
syntax on
filetype on
filetype plugin on
filetype indent on
  
" Highlight search terms...
set hlsearch
set incsearch " ...dynamically as they are typed.

" Custom config
" ===

" Indent after opening a block
set smartindent

" Set indenting to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Make background buffers work better
set hidden

" Make history much bigger
set history=5000

" Cycle through blocks of if and else with %
runtime macros/matchit.vim

" Make tab completion show menu
set wildmenu
set wildmode=list:longest

" Make searching ignore case, except if a capital letter is used
set ignorecase 
set smartcase

" Set the terminal title to describe the file
set title

" Make it so scrolling down gives you more lines of context
set scrolloff=3

" Store backup files in a centralised location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Make ctrl+e and ctrl+y scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Show line numbers in bottom right
set ruler

" Switch off search term highlighting with \n
nmap <silent> <leader>n :silent :nohlsearch<CR>

" Make it easy to show whitespace with \s
"set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Disable some annoying prompts (see :help shortmess)
set shortmess=atI

" Make colour scheme nicer
colorscheme desert

" 256 colours
" set t_Co=256

" Xdebug settings
let g:debuggerPort = 9001
let g:debuggerTimeout = 20

" Turn off mouse visual mode
set mouse-=a

