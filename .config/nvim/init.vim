" vim:fileformat=unix

let s:cache_dir = expand('~/.cache')
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = s:cache_dir . '/dein/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_dir)
    execute '!git clone --branch=3.1 --depth=1 https://github.com/Shougo/dein.vim' s:dein_dir
  endif
  execute 'set runtimepath^=' . substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')

  call dein#begin(s:cache_dir . '/dein')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/echodoc.vim')
  call dein#add('preservim/nerdtree')
  call dein#add('preservim/tagbar')
  call dein#add('vim-airline/vim-airline')
  call dein#add('tpope/vim-surround')
  call dein#add('morhetz/gruvbox')
  call dein#add('ojroques/vim-oscyank', {'rev': 'main'})
  call dein#end()
endif


set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:oscyank_silent = 1
"let g:echodoc#type = 'signature'

noremap <Leader>c :ccl <bar> lcl <bar> pclose<CR>
"let g:LanguageClient_hoverPreview = 'always'
"

let g:deoplete#enable_at_startup = 1
" coloring
set termguicolors
let g:gruvbox_italic=1
colorscheme gruvbox
set number
set cursorline

" folding
set foldmethod=syntax
set foldlevelstart=1
let xml_syntax_folding=1

"autocmd BufRead,BufNewFile *.py let python_highlight_all = 1
autocmd BufRead,BufNewFile *.py let c_space_errors=1
"autocmd BufRead,BufNewFile *.py set list lcs=tab:»·
autocmd BufRead,BufNewFile *.py set expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd BufRead,BufNewFile *.py set wrap tw=100

autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

let g:tagbar_autoshowtag = 1

"let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi link IndentGuidesOdd Normal
autocmd VimEnter,Colorscheme * :hi link IndentGuidesEven FoldColumn

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <S-F3> :exe IsNERDTreeOpen() ? 'NERDTreeToggle' : 'NERDTreeFind'<CR>
nnoremap <F15> :exe IsNERDTreeOpen() ? 'NERDTreeToggle' : 'NERDTreeFind'<CR>
nnoremap <F4> :set rnu!<CR>
nnoremap <F16> :IndentGuidesToggle<CR>
nnoremap <F8> :TagbarToggle<CR>
noremap <C-S> :TagbarOpen<CR>:TagbarShowTag<CR>

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

set mouse=vn

if empty($WAYLAND_DISPLAY) && empty($DISPLAY) && !has('win32')
  " I'd prefer to use ojroques/nvim-osc52 over ojroques/vim-oscyank but it requires
  " neovim >= 0.6 (debian bookworm+ or ubuntu 22.04+)
  autocmd TextYankPost *
      \ if v:event.operator is 'y' && (v:event.regname is '+' || v:event.regname is '') |
      \ execute 'OSCYankRegister ' . v:event.regname |
      \ endif
else
  set clipboard=unnamedplus
endif

noremap <M-LeftMouse> <4-LeftMouse>
inoremap <M-LeftMouse> <4-LeftMouse>
onoremap <M-LeftMouse> <C-C><4-LeftMouse>
noremap <M-LeftDrag> <LeftDrag>
inoremap <M-LeftDrag> <LeftDrag>
onoremap <M-LeftDrag> <C-C><LeftDrag>

set title titleold=

