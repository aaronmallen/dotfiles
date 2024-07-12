call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'phanviet/vim-monokai-pro'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

syntax on
filetype on
set number
set termguicolors
colorscheme monokai_pro

" ##############################
" Airline Configuration
" ##############################
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled=1
