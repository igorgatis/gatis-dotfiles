syntax on
set nocompatible  " be iMproved.
colorscheme desert
filetype off

filetype plugin indent on
set nohidden

"set term=xterm
" Search
set incsearch
set ignorecase
set smartcase
" Tabs and Identation
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set showtabline=2
set autoindent
"set smartindent
set cindent
set cinoptions=l1,g0.5s,h0.5s,i2s,+2s,(0,W2s
" Helpful stuff
set ruler
set showcmd
set showmatch
set showmode
set winminheight=0
set wildmenu wildmode=longest:full

set pastetoggle=<F2>
imap <TAB> <C-V><TAB>

" Move from window to window
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l
" Move between buffers
noremap <C-n> :bnext<CR>
noremap <C-p> :bprev<CR>

" Stores last edit position.
if has("autocmd")
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
endif


" Whitespacing
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
" Remove trailing spaces and tabs.
nmap ,gc :%s/[ <Tab>]\+$//<CR>

" Local stuff.
if filereadable(expand('$HOME/.vimrc_local'))
  source $HOME/.vimrc_local
endif
