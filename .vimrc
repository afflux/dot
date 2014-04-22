" vim:fileformat=unix
filet plugin indent on
syntax on
set background=dark
set grepprg=grep\ -nH\ $*
set modeline 
set vb

autocmd BufRead,BufNewfile *.asm set ft=gas

autocmd BufRead,BufNewFile *.py let python_highlight_all = 1
autocmd BufRead,BufNewFile *.py let c_space_errors=1 
autocmd BufRead,BufNewFile *.py set list lcs=tab:»·
autocmd BufRead,BufNewFile *.py set expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd BufRead,BufNewFile *.py set wrap tw=80
autocmd BufRead,BufNewFile *.py set autoindent

"autocmd BufNewFile,BufRead /home/k/build/gajim/* set noet ts=3 sw=3 sts=3 
let g:tex_flavor='latex'

set number
"let html_use_css='true'
"set mouse=a
autocmd BufRead,BufNewFile *.tex map  :w!:!clear; echo Making Postscript % ...; pdflatex % 
set cursorline
let g:solarized_termtrans = 1
colorscheme solarized

set laststatus=2
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
