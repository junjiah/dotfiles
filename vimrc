set encoding=utf-8
set nocompatible
set autowrite
set nu
filetype off

" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'git@github.com:fatih/vim-go.git'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_exec = 'python3'
let g:syntastic_python_flake8_args = ['-m', 'flake8']
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
let g:syntastic_aggregate_errors = 1
" Disable syntastic by default.
autocmd VimEnter * SyntasticToggleMode
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
let NERDTreeIgnore=['\.pyc$', '\~$'] " Ignore files in NERDTree
Plugin 'kien/ctrlp.vim'
" Always show statusline
set laststatus=2
Plugin 'flazz/vim-colorschemes'
Plugin 'elmcast/elm-vim'
let g:elm_format_autosave = 1
Plugin 'airblade/vim-gitgutter'
Plugin 'trevordmiller/nova-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme = 'monochrome'
Plugin 'kshenoy/vim-signature'
Plugin 'nsf/gocode', {'rtp': 'vim/'}

" After adding plugins.
call vundle#end()
filetype plugin indent on

" Split navigations.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Quick nav for errors.
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Nav back.
map <C-_> <C-o>

" Go.
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_metalinter_deadline = "15s"
let g:go_snippet_case_type = "camelcase"
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['golint', 'vet', 'errcheck']
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 0
let g:go_echo_command_info = 0
augroup go
  autocmd!
  autocmd Filetype go
    \  command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    \| command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    \| command! -bang AS call go#alternate#Switch(<bang>0, 'split')
augroup END

" PEP8.
au BufNewFile,BufRead *.py set tabstop=4
au BufNewFile,BufRead *.py set softtabstop=4
au BufNewFile,BufRead *.py set shiftwidth=4
au BufNewFile,BufRead *.py set textwidth=79
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py set autoindent
au BufNewFile,BufRead *.py set fileformat=unix

" Whitespace.
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Web stuff.
au BufNewFile,BufRead *.js,*.html,*.css set tabstop=2
au BufNewFile,BufRead *.js,*.html,*.css set softtabstop=2
au BufNewFile,BufRead *.js,*.html,*.css set shiftwidth=2
au BufNewFile,BufRead *.js set expandtab

" YouCompleteMe.
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g :YouCompleter GoToDefinitionElseDeclaration<CR>

" Python with virtualenv support.
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

let python_highlight_all=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|pyc)$'

" GUI fonts.
set guifont=SourceCodePro+Powerline+Awesome\ Regular:h12
if has('gui_running')
  set background=dark
  color ink
else
  color nova
  color ink
endif

" OCaml, with Merlin and ocp-indent.
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
let g:syntastic_ocaml_checkers = ['merlin']
execute "set rtp^=" . g:opamshare . "/ocp-indent/vim"
autocmd FileType ocaml map gd :MerlinLocate

" OCaml format.
au BufNewFile,BufRead *.ml set tabstop=2
au BufNewFile,BufRead *.ml set softtabstop=2
au BufNewFile,BufRead *.ml set shiftwidth=2
au BufNewFile,BufRead *.ml set expandtab
au BufNewFile,BufRead *.ml set autoindent
au BufNewFile,BufRead *.ml set fileformat=unix
autocmd BufWritePre *.ml %s/\s\+$//e

" Makefile.
au FileType make setlocal shiftwidth=2 tabstop=2
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line

" Learned from https://github.com/begriffs/haskell-vim-now/blob/master/.vimrc

if ! exists("g:mapleader")
  let mapleader = ","
endif

set tm=2000

set formatprg=par
let $PARINIT = 'rTbgqR B=.,?_A_a Q=_s>|'

nnoremap Q <nop>

set so=7

set wildmenu
set wildmode=list:longest,full

set smartcase
set incsearch
set lazyredraw
set showmatch
set mat=2

if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

hi Search ctermfg=white ctermbg=173 cterm=none guifg=#ffffff guibg=#e5786d gui=none
hi! link Visual Search

hi Cursor guibg=red

set guicursor=n-v-c:block-Cursor
set guicursor+=n-v-c:blinkon0

if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set guitablabel=%M\ %t
endif
set t_Co=256

set nobackup
set nowb
set noswapfile

nmap <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
nnoremap <silent> <Leader><space> :CtrlP<CR>
let g:ctrlp_max_files=0
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore = { 'dir': '\v[\/](.git|.cabal-sandbox|.stack-work)$' }

nnoremap j gj
nnoremap k gk

augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END

set viminfo^=%

set hidden

nnoremap <leader>bp :bp<cr>
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bd :bd<cr>
nnoremap <leader>b<space> :CtrlPBuffer<cr>

map <leader>ss :setlocal spell!<cr>

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! ToggleFindNerd()
  if IsNERDTreeOpen()
    exec ':NERDTreeToggle'
  else
    exec ':NERDTreeFind'
  endif
endfunction

nmap <silent> <leader>f <ESC>:call ToggleFindNerd()<CR>
nmap <silent> <leader>F <ESC>:NERDTreeToggle<CR>

set completeopt+=longest

" Map Ctrl-S to saving in both normal and insert mode.
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Use :w!! to save with sudo.
cmap w!! %!sudo tee > /dev/null %
