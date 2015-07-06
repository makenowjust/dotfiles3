# 24bit trueカラーで表示するようにする
set -g fish_term24bit 1

# PATHを設定
source ~/.config/fish/path.fish

# 起動時に何も表示しない
function fish_greeting
end

# notify_time以上時間がかかったとき、デスクトップに通知を行なう
# (単位はミリ秒)
set notify_time (math "30 * 1000")

function _prompt_notify -e fish_prompt
  if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt $notify_time
    set -l title
    if test $status -eq 0
      set title "Command finished"
    else
      set title "Command failed (status is $status)"
    end

    notify-send -a "terminal" $title $history[1]
  end
end

# aliasがバグってるとしか思えないので適当に直す
# https://github.com/fish-shell/fish-shell/issues/393
function alias --argument alias command
    set -l cmd (echo $command | sed 's/ /\n/g')[1]
    set -l prefix
    if type -q $cmd
      switch (type -t $cmd)
        case builtin
          set prefix builtin
        case file
          set prefix command
      end

      eval "function $alias; $prefix $command \$argv; end"
      complete -c $alias -xa "(
          set -l cmd (commandline -pc | sed -e 's/^ *\S\+ *//' );
          complete -C\"$command \$cmd\";
      )"
    end
end

# 元からあるコマンドにオプションを追加

alias rm 'rm -i'
alias mv 'mv -i'
alias cp 'cp -i'
alias emacs 'emacs -nw'
alias mkdir 'mkdir -p'
alias xclip 'xclip -selection clipboard'

# エイリアス
alias cls 'clear'

alias mh 'mv -t .'
alias ch 'cp -t .'

alias .. 'prevd'
alias ,, 'nextd'

# git as git + hub
alias git 'hub'

alias gst 'git status -s -b'
alias gcm 'git commit'
alias gcmm 'gcm -m'
alias gcma 'gcm -a'
alias gad 'git add'
alias gadp 'gad -p'
alias gps 'git push'
alias gpsu 'gps -u'
alias gpl 'git pull'
alias gf 'git fetch'
alias gm 'git merge'
alias gdiff 'git diff HEAD'
alias gcl 'git clone --recursive'
alias ginit 'git init'
alias glog 'git log'
alias greset 'git reset'
