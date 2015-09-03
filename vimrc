" vim: fdm=marker fdc=3

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

" NeoBundleとプラグインの読み込み {{{1
if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundleでNeoBundle自身を管理 {{{2
NeoBundleFetch 'Shougo/neobundle.vim'

" 起動時に読み込まれるもの {{{2

" vital.vim {{{3
NeoBundle 'vim-jp/vital.vim'

" VimProc {{{3
NeoBundle 'Shougo/vimproc.vim'

" statuslineをかっこよくする {{{3
NeoBundle 'itchyny/lightline.vim'

" 検索をいい感じに {{{3
NeoBundle 'haya14busa/incsearch.vim'

" Unite {{{3
NeoBundle 'Shougo/unite.vim'

" editorconfig {{{3
NeoBundle 'editorconfig/editorconfig-vim'

" ビジュアルモード全般を矩形選択的に {{{3
NeoBundle 'kana/vim-niceblock'

" カラースキーム {{{3
NeoBundle 'MakeNowJust/islenauts.vim'
NeoBundle 'MakeNowJust/islenauts-lightline.vim'


" 遅延読み込みされるもの {{{2

" VimShell {{{3
NeoBundleLazy 'Shougo/vimshell.vim'

" vim-quickrun {{{3
NeoBundleLazy 'thinca/vim-quickrun'

" Gist {{{3
NeoBundleLazy 'lambdalisue/vim-gista'

" ファイラ {{{3
NeoBundleLazy 'Shougo/vimfiler.vim'

" carc.in {{{3
NeoBundleLazy 'MakeNowJust/carcin.vim'

" 言語毎のシンタックスハイライトなど {{{2

" HTML5 {{{3
" NeoBundleLazy "othree/html5.vim"

" Stylus {{{3
NeoBundleLazy "wavded/vim-stylus"

" jade {{{3
NeoBundleLazy "digitaltoad/vim-jade"

" TOML {{{3
NeoBundleLazy 'cespare/vim-toml'

" fish shell {{{3
NeoBundleLazy 'dag/vim-fish'

" Crystal {{{3
NeoBundleLazy 'rhysd/vim-crystal'

" Ruby {{{3
NeoBundleLazy 'vim-ruby/vim-ruby'

" pegjs {{{3
NeoBundleLazy "alunny/pegjs-vim"

" pony {{{3
NeoBundleLazy "dleonard0/pony-vim-syntax"

" NeoBundleの終了処理 {{{2
call neobundle#end()

NeoBundleCheck

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
set breakindent

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
" set clipboard=unnamedplus
" ↑あると、削除時にもクリップボードに文字が入ってしまって微妙

" あいまいな文字の幅を2にする
set ambiwidth=double

" 折り畳みを有効にする
set foldenable

" 現在位置などを保存
set viewoptions=cursor,folds
augroup MYVIMRC
  au! BufWinLeave ?* silent mkview
  au! BufWinEnter ?* silent loadview
augroup END

" バックアップ
set backup
set backupdir=$HOME/\.vim_backup
set writebackup

" Undoの状態を保存
set undofile
set undodir=$HOME/\.vim_undo

" スワップファイルは作成しない
set noswapfile

" 自作の処理たち {{{1

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
  let ctermbold = synIDattr(a:synid, "bold", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  let guibold = synIDattr(a:synid, "bold", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "ctermbold": ctermbold,
        \ "guifg": guifg,
        \ "guibg": guibg,
        \ "guibold": guibold}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " cterm: " . (baseSyn.ctermbold == 1 ? "bold" : "") .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg .
        \ " gui: " . (baseSyn.guibold == 1 ? "bold" : "")
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " cterm: " . (linkedSyn.ctermbold == 1 ? "bold" : "") .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg .
        \ " gui: " . (linkedSyn.guibold == 1 ? "bold" : "")
endfunction
command! SyntaxInfo call s:get_syn_info()

" 選択範囲をcolorcolumnで指定 {{{2
function! s:visual_colorcolumn()
  let start = col("'<")
  let end = col("'>")
  let r = join(range(start, end), ",")
  if r == &cc
    setl cc=
  else
    exe 'setl cc=' . r
  endif
endfunction
command! -range VisualColorColumn call s:visual_colorcolumn()

" Vimプラグイン開発モード {{{2
" 起動時に末尾が.vimのディレクトリを開いた場合、runtimepathの先頭にそのディレクトリを追加
let s:m = matchstr(getcwd(), '\v^(.*(.vim|/vim-[^/]+)(/|$))')
if !empty(s:m)
  exe 'set rtp^=' . s:m
  if !empty(glob(s:m . '/,vimrc'))
    exe 'source ' . s:m . '/,vimrc'
  endif
endif
unlet s:m

" マッピングの設定 {{{1

" <C-p>と間違えると色々出てきてかなりウザいので
inoremap <C-@> <NOP>

" デフォルトのexコマンドを上書きしたい!
function! s:cmd_remap(char, command)
  exe 'cnoreabbrev <expr> ' . a:char . ' getcmdtype() == ":" && getcmdline() == "' . a:char . '" ? "' . a:command . '" : "' . a:char . '"'
endfunction

" みんなタブになればいい
call s:cmd_remap('e', 'tabe')
call s:cmd_remap('h', 'tab help')

noremap <silent> cc :<C-u>VisualColorColumn<CR>
noremap <silent> cl :<C-u>setl cursorcolumn!<CR>

inoremap <silent> z<Space> 　

inoremap <silent> <C-j> <NOP>

noremap <silent> j gj
noremap <silent> k gk
noremap <silent> gj j
noremap <silent> gk k

nnoremap <silent> <CR> :<C-u>w<CR>

" 各プラグインの設定 {{{1

" vimproc.vim {{{2
if neobundle#tap('vimproc.vim')
  call neobundle#config({
        \ 'build' : {
        \   'windows' : 'tools\\update-dll-mingw',
        \   'cygwin' : 'make -f make_cygwin.mak',
        \   'mac' : 'make -f make_mac.mak',
        \   'linux' : 'make',
        \   'unix' : 'gmake',
        \ },
        \})

  call neobundle#untap()
endif

" vimshell.vim {{{2
if neobundle#tap('vimshell.vim')
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [{ 'name' : 'VimShell',
        \                  'complete' : 'customlist,vimshell#complete'}],
        \   'command_prefix': 'VimShell',
        \ }})

  let g:vimshell_split_command = 'tabnew'

  call neobundle#untap()
endif

" islenauts.vim {{{2
if neobundle#tap('islenauts.vim')
  colorscheme islenauts

  " 背景を透過する
  hi Normal ctermbg=none
  hi NonText ctermbg=none
  hi CursorLine ctermbg=none
  " hi CursorColumn ctermbg=none

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

" vim-quickrun {{{2
if neobundle#tap('vim-quickrun')
  call neobundle#config({
        \ 'autoload' : {
        \   'command_prefix' : 'QuickRun',
        \ }})

  let g:quickrun_config = {}
  let g:quickrun_config._ = {
        \ 'runner': 'vimproc',
        \ 'runner/vimproc/updatetime': 60,
        \ 'outputter/buffer/split': ':botright',
        \ 'outputter/buffer/close_on_empty': 1,
        \ }

  " <C-c>でquickrunを強制終了させる
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

  nnoremap [quickrun] <Nop>
  nmap <Space>q [quickrun]

  nnoremap <silent> [quickrun]q :<C-u>QuickRun<CR>
  nnoremap <silent> [quickrun]o :<C-u>only<CR>

  call neobundle#untap()
endif

" lightline.vim {{{2
if neobundle#tap('lightline.vim')
  let g:lightline = {}
  let g:lightline.colorscheme = 'islenauts'
  let g:lightline.active = {}
  let g:lightline.active.left = [
        \ ['mode', 'paste'],
        \ ['filename', 'readonly', 'modified']
        \ ]
  let g:lightline.active.right = [
        \ ['percent', 'lineinfo', 'charcount'],
        \ ['filetype'],
        \ ['fileencoding', 'fileformat']
        \ ]
  let g:lightline.inactive = g:lightline.active
  let g:lightline.component_function = {
        \ 'fileformat': 'MyFileFormat',
        \ 'fileencoding': 'MyFileEncoding',
        \ 'charcount': 'MyCharCount',
        \ }

  function! MyFileFormat()
    return {
          \ 'unix': '"\n"',
          \ 'dos': '"\r\n"',
          \ 'mac': '"\r"',
          \ }[&ff]
  endfunction

  function! MyFileEncoding()
    return (&fenc == '' ? &enc : &fenc) . (&bomb ? '+bomb' : '')
  endfunction

  function! MyCharCount()
    return strchars(join(getline(1, '$'), "\n"))
  endfunction

  call neobundle#untap()
endif

" vim-gista {{{2
if neobundle#tap('vim-gista')
  call neobundle#config({
      \ 'autoload': {
      \   'commands': ['Gista'],
      \   'mappings': '<Plug>(gista-',
      \   'unite_sources': 'gista',
      \ }})

  let g:gista#github_user = 'MakeNowJust'
  " タブで開いてくれると嬉しいかなって
  let g:gista#list_opener = 'tabe'
  let g:gista#gist_openers = {
        \ 'edit': 'tabe',
        \ 'split': 'rightbelow split',
        \ 'vsplit': 'rightbelow split',
        \ }

  call neobundle#untap()
endif

" vimfiler.vim {{{2
if neobundle#tap('vimfiler.vim')
  call neobundle#config({
        \ 'autoload' : {
        \    'commands' : [{ 'name' : 'VimFiler',
        \                    'complete' : 'customlist,vimfiler#complete' },
        \                  'VimFilerExplorer',
        \                  'Edit', 'Read', 'Source', 'Write'],
        \    'mappings' : '<Plug>',
        \    'explorer' : 1,
        \ }
        \})

  function! neobundle#tapped.hooks.on_source(bundle)
    " デフォルトのファイラとして指定
    let g:vimfiler_as_default_explorer = 1

    " セーフモードを無効にして、タブで開く
    call vimfiler#custom#profile('default', 'context', {
          \ 'safe': 0,
          \ 'edit_action': 'tabopen',
          \ })
  endfunction

  call neobundle#untap()
endif

" pegjs-vim {{{2
if neobundle#tap('pegjs-vim')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['pegjs'],
        \ }})

  call neobundle#untap()
endif

" html5.vim {{{2
if neobundle#tap('html5.vim')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['html'],
        \ }})

  call neobundle#untap()
endif

" vim-jade {{{2
if neobundle#tap('vim-jade')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['jade'],
        \ }})

  call neobundle#untap()
endif

" vim-stylus {{{2
if neobundle#tap('vim-stylus')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['stylus'],
        \ }})

  call neobundle#untap()
endif

" vim-toml {{{2
if neobundle#tap('vim-toml')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['toml'],
        \ }})

  call neobundle#untap()
endif

" vim-fish {{{2
if neobundle#tap('vim-fish')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['fish'],
        \ }})

  call neobundle#untap()
endif

" vim-crystal {{{2
if neobundle#tap('vim-crystal')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['crystal', 'markdown'],
        \ }})

  call neobundle#untap()
endif

" vim-ruby {{{2
if neobundle#tap('vim-ruby')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['ruby', 'markdown'],
        \ }})

  call neobundle#untap()
endif

" pony-vim-syntax {{{2
if neobundle#tap('pony-vim-syntax')
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['pony'],
        \ }})

  call neobundle#untap()
endif

" シンタックスハイライトの設定 {{{1

" Markdownでハイライト可能な言語の指定
let g:markdown_fenced_languages = [
      \ 'css',
      \ 'javascript', 'js=javascript',
      \ 'json',
      \ 'ruby',
      \ 'viml=vim',
      \ 'crystal',
      \ ]

" シンタックスハイライトを有効にする
if !has('gui_running')
  set t_Co=256
endif
syntax enable

"  filetypeを有効にする {{{1
filetype plugin indent on
