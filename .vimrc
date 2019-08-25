set cindent
set smartindent
set expandtab         " 将tab自动转为空格
set tabstop=4
set softtabstop=4     " tab转为多少个空格
set mouse=a           " 支持使用鼠标
set encoding=utf-8    " 使用utf-8编码
set t_Co=256          " 启用256色
" 上下显示多余3行
set scrolloff=3

" plug
call plug#begin()
" 状态栏主题
Plug 'itchyny/lightline.vim'
" 主题
Plug 'joshdick/onedark.vim'
" 目录树
Plug 'scrooloose/nerdtree'

call plug#end()


" theme
" 语法高亮
syntax on
" 显示行号
set number
" 行号宽度
set numberwidth=4
" 启用256色
set t_Co=256
" 状态栏始终显示
set laststatus=2
" Set to 1 if you want to hide end-of-buffer filler lines (~) for a cleaner look; 0 otherwise (the default).
let g:onedark_hide_endofbuffer=1
" Set to 1 if your terminal emulator supports italics; 0 otherwise (the default).
let g:onedark_terminal_italics=1
colorscheme onedark
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

""""""""""""""""""""""""""""
" map
let mapleader = ','
""""""""""""""""""""""""""""
" nerdtree
map <C-n> :NERDTreeToggle<CR>
