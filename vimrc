" ~/.vimrc — symlinked from the dotfiles repo
" Plugins live in ~/.vim/bundle (git submodules), loaded by pathogen.

" ── Pathogen ─────────────────────────────────────────────────────────────────
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

" fzf binary's vim plugin (needed by fzf.vim)
if isdirectory('/opt/homebrew/opt/fzf')
  set rtp+=/opt/homebrew/opt/fzf
endif

" ── General ──────────────────────────────────────────────────────────────────
let mapleader = ' '
set encoding=utf-8
set hidden                      " switch buffers without saving
set mouse=a
set clipboard=unnamed           " use the macOS clipboard
set updatetime=250              " faster gitgutter updates
set timeoutlen=500
set noswapfile
set nobackup nowritebackup
set undofile
let s:state = expand('~/.local/state/vim')
for s:d in ['undo']
  if !isdirectory(s:state . '/' . s:d) | call mkdir(s:state . '/' . s:d, 'p') | endif
endfor
let &undodir = s:state . '/undo'
let &viminfofile = s:state . '/viminfo'

" ── UI ───────────────────────────────────────────────────────────────────────
set number relativenumber
set cursorline
set signcolumn=yes
set noshowmode                  " lightline shows the mode
set laststatus=2
set showcmd
set splitright splitbelow
set scrolloff=8 sidescrolloff=8
set nowrap
set list listchars=tab:»\ ,trail:·,nbsp:␣
set fillchars+=vert:│
set shortmess+=c

if has('termguicolors')
  set termguicolors
  " true color inside tmux
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
" Cursor: bar in insert mode, block otherwise (iTerm2 + tmux)
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

silent! colorscheme catppuccin_mocha
let g:lightline = {
      \ 'colorscheme': 'catppuccin_mocha',
      \ 'active': {
      \   'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified']],
      \ },
      \ 'component_function': { 'gitbranch': 'FugitiveHead' },
      \ }

" ── Editing ──────────────────────────────────────────────────────────────────
set expandtab shiftwidth=4 tabstop=4 softtabstop=4   " vim-sleuth adapts per file
set smartindent
set ignorecase smartcase
set hlsearch incsearch
set wildmode=longest:full,full

" ── Keys ─────────────────────────────────────────────────────────────────────
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Move selected lines with J/K, keep selection when indenting
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

" Buffers
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Splits: C-h/j/k/l handled by vim-tmux-navigator (works across tmux panes)

" ── Plugins ──────────────────────────────────────────────────────────────────
" fzf.vim
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>h :History<CR>
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7, 'border': 'rounded' } }

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>N :NERDTreeFind<CR>
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['\.git$', '\.DS_Store$', '__pycache__', 'node_modules']
" Close vim if NERDTree is the last window
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Fugitive
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

" GitGutter: ]c / [c jump between hunks
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▁'

" ALE (linting/fixing with whatever tools are installed)
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:ale_fix_on_save = 0
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }
nnoremap <leader>af :ALEFix<CR>
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)

" Undotree
nnoremap <leader>u :UndotreeToggle<CR>

" ── Autocommands ─────────────────────────────────────────────────────────────
augroup vimrc
  autocmd!
  " Return to last cursor position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g`\"" | endif
  " 2-space indent for these
  autocmd FileType javascript,typescript,json,yaml,html,css,lua,ruby setlocal sw=2 ts=2 sts=2
  " Git commit messages
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END

" Machine-specific overrides
if filereadable(expand('~/.vimrc.local')) | source ~/.vimrc.local | endif
