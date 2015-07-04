if !1 | finish | endif

set nocompatible

if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundleでNeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \   'windows' : 'tools\\update-dll-mingw',
      \   'cygwin' : 'make -f make_cygwin.mak',
      \   'mac' : 'make -f make_mac.mak',
      \   'linux' : 'make',
      \   'unix' : 'gmake',
      \ },
      \}

" カラースキーム
NeoBundle 'MakeNowJust/islenauts.vim'

" 検索をいい感じに
NeoBundle 'haya14busa/incsearch.vim'

" statuslineをかっこよくする
NeoBundle 'itchyny/lightline.vim'

" 言語毎のシンタックスハイライトなど

" TOML
NeoBundle 'cespare/vim-toml'

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

" コマンドラインの行数を2にする
set cmdheight=2

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

" バックスペースでインデント、改行を削除
set backspace=indent,eol,start

" カーソルでの移動時に行末、行頭で止まらないようにする
set whichwrap=b,s

" シンタックスハイライトの設定
syntax on
if !has('gui_running')
  set t_Co=256
endif
color islenauts

" 背景を透過する
hi Normal ctermbg=none
hi NonText ctermbg=none

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backword)
map g/ <Plug>(incsearch-stay)

" <C-p>と間違えると色々出てきてかなりウザいので
inoremap <C-@> <Nop>

" デフォルトのExコマンドを上書きしたい!
function! s:CmdRemap(char, command)
  exe 'cnoreabbrev <expr> ' . a:char . ' getcmdtype() == ":" && getcmdline() == "' . a:char . '" ? "' . a:command . '" : "' . a:char . '"'
endfunction

" みんなタブになればいい
call s:CmdRemap('e', 'tabe')
call s:CmdRemap('h', 'tab help')

" 現在位置のシンタックス情報を取得する
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
