" vim: fdm=marker fdc=3 fdl=0

" 互換性 {{{1
if !1 | finish | endif

set nocompatible

" その他初期化 {{{1
" 忘れないうちに全部消しておく
augroup MYVIMRC
  au!
augroup END

" fish-shellはVimに向かない
set shell=/bin/bash

" Vimに付属のプラグイン {{{1
source $VIMRUNTIME/macros/matchit.vim

" NeoBundleとプラグインの読み込み {{{1
if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundleでNeoBundle自身を管理 {{{2
NeoBundleFetch 'Shougo/neobundle.vim'

" VimProc {{{2
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \   'windows' : 'tools\\update-dll-mingw',
      \   'cygwin' : 'make -f make_cygwin.mak',
      \   'mac' : 'make -f make_mac.mak',
      \   'linux' : 'make',
      \   'unix' : 'gmake',
      \ },
      \}

" カラースキーム {{{2
NeoBundle 'MakeNowJust/islenauts.vim'

" 検索をいい感じに {{{2
NeoBundle 'haya14busa/incsearch.vim'

" statuslineをかっこよくする {{{2
NeoBundle 'itchyny/lightline.vim'

" 言語毎のシンタックスハイライトなど {{{2

" TOML {{{3
NeoBundle 'cespare/vim-toml'

" fish shell {{{3
NeoBundle 'dag/vim-fish'

" NeoBundleの終了処理 {{{2
call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" Vimプラグイン開発モード {{{2
" 起動時に末尾が.vimのディレクトリを開いた場合、runtimepathの先頭にそのディレクトリを追加
let s:m = matchstr(getcwd(), '\v^(.*\.vim(/|$))')
if !empty(s:m)
  exe 'set rtp^=' . s:m
endif
unlet s:m

" set系 {{{1

" 行番号の表示
set number
set numberwidth=6

" 相対的な行番号を表示する
set relativenumber

" タブ文字や末尾の空白を可視化
set list
set listchars=tab:>-,extends:<,trail:-

" statuslineを常に表示
set laststatus=2

" コマンドラインの行数を2にする
set cmdheight=2

" tablineを常に表示
set showtabline=2

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

" 行に余裕があるうちにスクロール
set scrolloff=10

" バックスペースでインデント、改行を削除
set backspace=indent,eol,start

" カーソル/Backspaceでの移動時に行末、行頭で止まらないようにする
set whichwrap=b,s

" 検索結果を強調する
set hlsearch

" 3行目までをmodelineとする
set modeline
set modelines=3

" システムのクリップボードと共有する
set clipboard=unnamedplus

" シンタックスハイライトを有効にする {{{1
"
" Markdownでハイライト可能な言語の指定
let g:markdown_fenced_languages = [
      \ 'css',
      \ 'javascript', 'js=javascript',
      \ 'json',
      \ 'ruby',
      \ 'viml=vim',
\]

" シンタックスハイライトの設定
syntax on
if !has('gui_running')
  set t_Co=256
endif

" マッピングの設定 {{{1

" <C-p>と間違えると色々出てきてかなりウザいので
inoremap <C-@> <Nop>

" デフォルトのExコマンドを上書きしたい!
function! s:cmd_remap(char, command)
  exe 'cnoreabbrev <expr> ' . a:char . ' getcmdtype() == ":" && getcmdline() == "' . a:char . '" ? "' . a:command . '" : "' . a:char . '"'
endfunction

" みんなタブになればいい
call s:cmd_remap('e', 'tabe')
call s:cmd_remap('h', 'tab help')

" 自作コマンド類 {{{1

" 現在位置のシンタックス情報を取得する {{{2
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

" 各プラグインの設定 {{{1

" islenauts.vim {{{2
if neobundle#tap('islenauts.vim')
  colorscheme islenauts

  " 背景を透過する
  hi Normal ctermbg=none
  hi NonText ctermbg=none
  hi CursorLine ctermbg=none
  hi CursorColumn ctermbg=none

  call neobundle#untap()
endif

" incsearch.vim {{{2
if neobundle#tap('incsearch.vim')
  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stey)

  let g:incsearch#auto_nohlsearch = 1
  map n <Plug>(incsearch-nohl-n)
  map N <Plug>(incsearch-nohl-N)
  map * <Plug>(incsearch-nohl-*)
  map # <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)

  call neobundle#untap()
endif
