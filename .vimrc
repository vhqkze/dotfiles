set cindent
set smartindent
set expandtab         " 将tab自动转为空格
set tabstop=4
set softtabstop=4     " tab转为多少个空格
set mouse=a           " 支持使用鼠标
set encoding=utf-8    " 使用ullllltf-8编码
set t_Co=256          " 启用256色
" 上下显示多余3行
set scrolloff=3
" 搜索时忽略大小写
set ignorecase
" 高亮搜索结果，所有结果都高亮显示，而不是只显示一个匹配
set hlsearch
" 逐步搜索模式，对当前键入的字符进行搜索而不必等待键入完成
set incsearch
" 重新搜索，在搜索到文件头或尾时，返回继续搜索，默认开启
set wrapscan



"""""""""""""""""""""""""""
" 插件vim-plug设置
"""""""""""""""""""""""""""
call plug#begin()
" 状态栏主题
Plug 'itchyny/lightline.vim'
" 主题
Plug 'joshdick/onedark.vim'
" 目录树
Plug 'scrooloose/nerdtree'
" 中文帮助文档
Plug 'yianwillis/vimcdoc'
" supertab
Plug 'ervandew/supertab'
" comment
Plug 'scrooloose/nerdcommenter'

" deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
" deoplete python
Plug 'zchee/deoplete-jedi'
call plug#end()



"""""""""""""""""""""""""""
" 主题及样式设置
"""""""""""""""""""""""""""
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
" 快捷键设置
""""""""""""""""""""""""""""
let mapleader = ','
inoremap jj <ESC>



""""""""""""""""""""""""""""
" 插件设置
""""""""""""""""""""""""""""
" nerdtree
map <C-n> :NERDTreeToggle<CR>


" deoplete
let g:deoplete#enable_at_startup = 1


" yianwillis/vimcdoc
set helplang=cn 

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>" 

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
