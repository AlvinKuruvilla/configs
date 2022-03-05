set background=dark
set number                     " Show current line number
set relativenumber
set termguicolors " **This is probably why some of the gruvbox changes haven't been working, I have been editing cterm colors instead of gui colors
" Some native file handling
set wildmenu
set wildignore+=**/node_modules/**
set backspace=2 " Backspace over newlines

call plug#begin('~/.config/nvim/plugged')
call plug#begin()

" Aesthetics - Main
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#begin("~/.vim/plugged")
  " Plugin Section
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'itchyny/lightline.vim'
  Plug 'machakann/vim-highlightedyank'
  Plug 'andymass/vim-matchup'
  Plug 'eemed/sitruuna.vim'
  " Completions
  Plug 'ncm2/ncm2'
  Plug 'roxma/nvim-yarp'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'rhysd/vim-clang-format'
Plug 'dag/vim-fish'
Plug 'plasticboy/vim-markdown'

" Rainbow Brackets
Plug 'frazrepo/vim-rainbow'

"Emmet support
Plug 'mattn/emmet-vim'

"Bulk commenting
Plug 'preservim/nerdcommenter'
"Bracket pair complete
Plug 'jiangmiao/auto-pairs'
Plug 'https://github.com/joshdick/onedark.vim.git'

Plug 'ciaranm/securemodelines'
"Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

call plug#end()

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
let g:onedark_config = {
    \ 'style': 'warm',
\}
syntax enable on
"colorscheme onedark
colorscheme base16-atelier-dune
"colorscheme srcery
"colorscheme hybrid
autocmd! bufwritepost $HOME/.mar:slo/.vimrc silent! source %

filetype plugin indent on

let g:lightline = {
      \ 'colorscheme': 'sitruuna',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

let g:rainbow_active = 1

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

let mapleader = "\<Space>"
" save using SPACE + w
nnoremap <leader>w : w<cr>

"COC Setup
let g:coc_node_path = "/usr/local/bin/node"
let g:python3_host_prog = "/usr/local/bin/python3"

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

" Searching in Vim Cheatsheet: https://thevaluable.dev/vim-search-find-replace/
noremap <silent> <C-o> :Buffers<CR>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

"Persistant Cursor
autocmd BufLeave,BufWinLeave * silent! mkview
autocmd BufReadPost * silent! loadview

" Enable type inlay hints
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }

" Completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" Use <Tab> and <S-Tab> to navigate through popup menu
 inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
 inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
 set cmdheight=2
