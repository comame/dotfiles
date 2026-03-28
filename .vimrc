set encoding=utf-8

syntax on
filetype plugin indent on

set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

set mouse=
set title
set ruler
set number
set hidden
set autoread
set splitright
set imdisable
set showcmd
set wrap
set nolinebreak
set fileencodings=utf-8

set hlsearch
set showmatch
set ignorecase
set smartcase

set list
set listchars=trail:·,extends:»,precedes:«,nbsp:%

let ff_map={'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}
" [RO] ~/.vimrc [+]
set statusline=%r\ %f\ %m
set statusline+=%=
" 30/60 (50%)  utf-8  LF  markdown
set statusline+=%l/%L\ (%p%%)\ \ %{&fileencoding}\ \ %{ff_map[&ff]}\ \ %{&filetype}
set laststatus=2

noremap <S-w> <C-w>
noremap <C-h> :wincmd<Space>h<Enter>
noremap <C-l> :wincmd<Space>l<Enter>
noremap <C-j> :wincmd<Space>j<Enter>
noremap <C-k> :wincmd<Space>k<Enter>
noremap <S-k> :bprev<Enter>
noremap <S-j> :bnext<Enter>
noremap <S-l> :tabnext<Enter>
noremap <S-h> :tabprevious<Enter>
noremap <Esc><Esc> :noh<Enter>
tnoremap <Esc><Esc> <C-w>N
" よく使うショートカットをメモしておく
" NORMAL: C-u, C-d PageUp,Down
" NORMAL: mark m[a-zA-Z], jump '[a-zA-Z]
" NORMAL: C-o jump prev, C-i jump next
" NORMAL: w word next, b word prev
" INSERT: C-t more indent, C-d less indent

" 拡張子ごとの設定
if has("autocmd")
   autocmd FileType markdown setlocal shiftwidth=2 tabstop=2
endif

" 保存時に末尾のスペースを消去
if has("autocmd")
    autocmd BufWritePost * %s/\s\+$//ge
endif

" カーソル位置の復元
if has("autocmd")
  augroup redhat
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

" DiffOrig の定義
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  \ | wincmd p | diffthis

" ShowSpace の定義
command ShowSpace setlocal listchars=space:·,trail:·,extends:»,precedes:«,nbsp:%
command NoShowSpace setlocal listchars=trail:·,extends:»,precedes:«,nbsp:%

" gvim の設定
if has("gui_running")
  set guifont=Monospace\ 16
  colorscheme desert
endif
