" vim:fileformat=unix
execute pathogen#infect()

set hidden
", 'tcp://127.0.0.1:2087'
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['/home/kb/apps/pls-venv/bin/pyls'],
    \ }

"    \ 'c': ['/home/kb/apps/cquery-env/bin/cquery', '--log-file=/tmp/cq.log'],
"    \ 'cpp': ['/home/kb/apps/cquery-env/bin/cquery', '--log-file=/tmp/cq.log'],
"
function! LanguageClientMaps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
        nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

	"turn off line-breaking as the LanguageServer will mess up if you type fast enough
	setl textwidth=0

        setl formatexpr=LanguageClient#textDocument_rangeFormatting()
	set completefunc=LanguageClient#complete
    endif
    nmap <silent> <F5> <Plug>(lcn-menu)
    vmap <silent> <F5> <Plug>(lcn-menu)
    nmap <leader>ld <Plug>(lcn-definition)
    nmap <leader>lr <Plug>(lcn-rename)
    nmap <leader>lf <Plug>(lcn-format)
    nmap <leader>lt <Plug>(lcn-type-definition)
    nmap <leader>lx <Plug>(lcn-references)
    nmap <silent> <leader>le <Plug>(lcn-explain-error)
    nmap <silent> <leader>la <Plug>(lcn-code-action)
    vmap <silent> <leader>la <Plug>(lcn-code-action)
    nmap <silent> <leader>lh <Plug>(lcn-hover)
    "nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
endfunction

set cmdheight=2
let g:echodoc#enable_at_startup = 1
"let g:echodoc#type = 'signature'

noremap <Leader>c :ccl <bar> lcl <bar> pclose<CR>
"let g:LanguageClient_hoverPreview = 'always'
"
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_settingsPath = [ expand('<sfile>:p:h') . '/settings.json', '.lsp.json' ]
let g:LanguageClient_changeThrottle = 2

augroup LanguageClient_config
  au!
  au BufEnter * let b:Plugin_LanguageClient_started = 0
  au User LanguageClientStarted setl signcolumn=yes
  au User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
  au User LanguageClientStarted call LanguageClientMaps()
  au User LanguageClientStopped setl signcolumn=auto
  au User LanguageClientStopped let b:Plugin_LanguageClient_started = 0
  au CursorMoved * if exists("b:Plugin_LanguageClient_started") && b:Plugin_LanguageClient_started | sil call LanguageClient#textDocument_documentHighlight() | endif
augroup END

let g:deoplete#enable_at_startup = 1
" coloring
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-solarized-dark
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

let s:vimrc_ext = fnamemodify(expand("$MYVIMRC"), ":p:h") . "/vimrc2"
if filereadable(s:vimrc_ext)
  execute ":source " . s:vimrc_ext
endif

set mouse=vn
set clipboard=unnamedplus

noremap <M-LeftMouse> <4-LeftMouse>
inoremap <M-LeftMouse> <4-LeftMouse>
onoremap <M-LeftMouse> <C-C><4-LeftMouse>
noremap <M-LeftDrag> <LeftDrag>
inoremap <M-LeftDrag> <LeftDrag>
onoremap <M-LeftDrag> <C-C><LeftDrag>

set title titleold=
