" vim:fileformat=unix
execute pathogen#infect()

" coloring
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-solarized-dark
set hlsearch
set modeline
set number
set cursorline

" no audible bell
set visualbell

" folding
set foldmethod=syntax
set foldlevelstart=1
let xml_syntax_folding=1

autocmd BufRead,BufNewFile *.py let python_highlight_all = 1
autocmd BufRead,BufNewFile *.py let c_space_errors=1
autocmd BufRead,BufNewFile *.py set list lcs=tab:»·
autocmd BufRead,BufNewFile *.py set expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd BufRead,BufNewFile *.py set wrap tw=100

set laststatus=2
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

let g:tagbar_autoshowtag = 1
let g:syntastic_mode_map = {"mode": "passive"}

"let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi link IndentGuidesOdd Normal
autocmd VimEnter,Colorscheme * :hi link IndentGuidesEven FoldColumn

if has('gui_win32')
  set backupdir=$VIM/backup//
  set directory=$VIM/swap//
  set undodir=$VIM/undo//
  let g:tagbar_ctags_bin='$USERPROFILE\cw\usr\local\bin\ctags.exe'
  set guifont=DejaVu_Sans_Mono:h10
endif

nnoremap <C-E> :NERDTreeToggle<CR>
nnoremap <F8> :TagbarToggle<CR>
noremap <C-S> :TagbarOpen<CR>:TagbarShowTag<CR>
