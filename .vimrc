if 0 | endif

set nocompatible

if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundleでNeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'

" カラースキーム
NeoBundle 'sjl/badwolf'

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" 行番号の表示
set number
set numberwidth=6

" タブ文字や末尾の空白を可視化
set list
set listchars=tab:>-,extends:<,trail:-

" statuslineを常に表示
set laststatus=2

" タブは基本2文字幅で
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" 行が長いときに自動で改行(物理)しないようにして、見た目だけ改行するようにする
set textwidth=0
set wrap
set showbreak=+\ 
if (v:version == 704 && has("patch338") || v:version >= 705)
  set breakindent
endif

" 現在行を強調する
set cursorline

" シンタックスハイライトの設定
syntax on
set t_Co=256
color badwolf
" 背景を透過する
hi Normal ctermbg=none
hi NonText ctermbg=none
