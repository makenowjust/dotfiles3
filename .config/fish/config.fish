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
    eval "function $alias; $command \$argv; end"
    complete -c $alias -xa "(
        set -l cmd (commandline -pc | sed -e 's/^ *\S\+ *//' );
        complete -C\"$command \$cmd\";
    )"
end

# 元からあるコマンドにオプションを追加

alias rm 'rm -i'
alias mv 'mv -i'
alias cp 'cp -i'

alias mkdir 'mkdir -p'

# エイリアス
alias cls 'clear'
alias mh 'mv -t .'
alias ch 'cp -t .'

alias gst 'git status -s -b'
alias gcm 'git commit'
alias gcmm 'gcm -m'
alias gcma 'gcm -a'
alias gad 'git add'
alias gadp 'gad -p'
