syntax on             " 语法高亮
set number            " 显示行号
set numberwidth=4     " 行号宽度
set cursorline        " 高亮当前行

set smartindent       " 智能缩进
set expandtab         " 输入tab自动转为空格
set tabstop=4         " 设置tab字符显示宽度
set softtabstop=4     " tab转为多少个空格
set shiftwidth=4      " 自动缩进时，缩进长度为4

set mouse=a           " 支持使用鼠标
set encoding=utf-8    " 使用utf-8编码
set t_Co=256          " 启用256色
set laststatus=2      " 状态栏始终显示
set scrolloff=3       " 上下显示多余3行

set ignorecase        " 搜索时忽略大小写
set smartcase         " 如果有一个大写字母，则切换到大小写敏感查找
set hlsearch          " 高亮搜索结果，所有结果都高亮显示，而不是只显示一个匹配
set incsearch         " 逐步搜索模式，对当前键入的字符进行搜索而不必等待键入完成
set wrapscan          " 重新搜索，在搜索到文件头或尾时，返回继续搜索，默认开启
set backspace=2



" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  " 1724126 - do not open new file with .spec suffix with spec file template
  " apparently there are other file types with .spec suffix, so disable the
  " template
  " autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
endif



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
" supertab
Plug 'ervandew/supertab'
" comment
Plug 'scrooloose/nerdcommenter'
" 自动补全
Plug 'neoclide/coc.nvim',{'branch':'release'}
" 彩虹括号
Plug 'luochen1990/rainbow'
" 自动关闭括号
Plug 'raimondi/delimitmate'
call plug#end()



""""""""""""""""""""""""""""
" 快捷键设置
""""""""""""""""""""""""""""
let mapleader = ','
inoremap jj <ESC>



"""""""""""""""""""""""""""
" 插件设置
"""""""""""""""""""""""""""
" joshdick/onedark.vim
" Set to 1 if you want to hide end-of-buffer filler lines (~) for a cleaner look; 0 otherwise (the default).
let g:onedark_hide_endofbuffer=1
" Set to 1 if your terminal emulator supports italics; 0 otherwise (the default).
let g:onedark_terminal_italics=0
colorscheme onedark


" itchyny/lightline.vim
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

" scrooloose/nerdtree
map <C-n> :NERDTreeToggle<CR>


" ervandew/supertab
let g:SuperTabDefaultCompletionType = "<c-n>" 


" luochen1990/rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
