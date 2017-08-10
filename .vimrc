set nocompatible  " be iMproved.
filetype off

filetype plugin indent on
syntax on
set nohidden

set term=xterm
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

"-----------------------------------------------------------------------------
" Key mappings

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

" Switch between .h / -inl.h / .cc / .py / .js / _test.* / _unittest.* / _mock.h
let pattern = '\(\(_\(unit\)\?test\)\?\.\(cc\|js\|py\)\|\(-inl\|_mock\)\?\.h\)$'
nmap ,c :e <C-R>=substitute(expand("%"), pattern, ".cc", "")<CR><CR>
nmap ,h :e <C-R>=substitute(expand("%"), pattern, ".h", "")<CR><CR>
nmap ,i :e <C-R>=substitute(expand("%"), pattern, "-inl.h", "")<CR><CR>
nmap ,t :e <C-R>=substitute(expand("%"), pattern, "_test.", "") . substitute(expand("%:e"), "h", "cc", "")<CR><CR>
nmap ,u :e <C-R>=substitute(expand("%"), pattern, "_unittest.", "") . substitute(expand("%:e"), "h", "cc", "")<CR><CR>
nmap ,m :e <C-R>=substitute(expand("%"), pattern, "_mock.h", "")<CR><CR>
nmap ,p :e <C-R>=substitute(expand("%"), pattern, ".py", "")<CR><CR>
nmap ,j :e <C-R>=substitute(expand("%"), pattern, ".js", "")<CR><CR>
" Opens BUILD file on the side.
nmap ,b :vs <C-R>=expand("%:h")."/build.gyp"<CR><CR>

" Copies (r)elative and (a)bsolute paths.
nmap ,fr :let @*=expand("%")<CR>   :echomsg expand('%')<CR>
nmap ,fa :let @*=expand("%:p")<CR> :echomsg expand('%:p')<CR>

" Remove trailing spaces and tabs.
nmap ,gc :%s/[ <Tab>]\+$//<CR>

" Shortcut to NERDTree
let NERDTreeCaseSensitiveSort = 1
let NERDTreeAutoDeleteBuffer = 1
nmap ,nt :NERDTree<CR>


"-----------------------------------------------------------------------------
" Plugins.

if &diff
  " Diff highlighting
  source $HOME/.vim/diff.vim
  autocmd VimEnter * call DiffSetup()
else
  " Restore last line position when editing a file again.
  set viminfo='10,\"100,:20,r/tmp,r/usr/local/google/tmp,n~/.viminfo
  "set viminfo='10,\"100,:20,r/tmp,n~/.viminfo
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
endif

" Highlight trailing spaces and 80+ characters long lines
func! HighlightTooLongLines()
  highlight TrailingChars ctermfg=black ctermbg=cyan guifg=black guibg=cyan
  "match TrailingChars '\(\s\+$\|\(^.\{80,\}\)\@<=.\)'
  match TrailingChars /\%81v.\+/
  let b:trainling_chars_hl = 1
endfunc
augroup filetypedetect
  au BufNewFile,BufRead * call HighlightTooLongLines()
augroup END

func! ToggleHighlightTooLongLines()
  if exists("b:trainling_chars_hl") && b:trainling_chars_hl
    highlight clear TrailingChars
    let b:trainling_chars_hl = 0
    echo "Trailing char highlight off."
  else
    call HighlightTooLongLines()
    echo "Trailing char highlight on."
  endif
endfunc
map <silent> <F6> <Esc>:call ToggleHighlightTooLongLines()<CR>

source $HOME/.vim/spell.vim

" Local stuff.
if filereadable(expand('$HOME/.vimrc_local'))
  source $HOME/.vimrc_local
endif
