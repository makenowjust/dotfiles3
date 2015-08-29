# $TERMを256対応してることにしたい
if test "$TERM" = "xterm"
  set -gx TERM xterm-256color
end

# 24bit trueカラーで表示するようにする
if test $TERM == 'xterm-256color'
  set -g fish_term24bit 1
end

# PATHを設定
source ~/.config/fish/env.fish

# あとは対話シェル以外では実行しなくてもいい
if status --is-interactive

  # 起動時に何も表示しない
  set fish_greeting

  # notify_time以上時間がかかったとき、デスクトップに通知を行なう
  # (単位はミリ秒)
  set notify_time (math "30 * 1000")


  function _prompt_notify -e fish_prompt
    set -g prompt_status $status
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

  set is_black 162324
  set is_white EDF2F2
  set is_gray1 B5C9C9
  set is_gray2 839191
  set is_gray3 565959
  set is_gray4 262727
  set is_red F04341
  set is_green A4FA87
  set is_yellow F0E09E
  set is_magenta F06EE2
  set is_blue 7377FA
  set is_cyan 74E3DA

  set color_success $is_black $is_green
  set color_fail $is_white $is_magenta
  set fg_host $is_black
  set bg_host $is_gray2
  set fg_pwd $is_white
  set bg_pwd $is_gray3
  set fg_prompt $is_white
  set bg_prompt $is_black
  set fg_git_success $is_green
  set fg_git_fail $is_red
  set fg_git_add $is_green
  set fg_git_modify $is_red
  set fg_git_unknown $is_yellow

  function fish_prompt --description 'Write out the prompt'
    set prompt_status $status

    # Just calculate this once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
      set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    set -l suffix
    switch $USER
    case root toor
      set suffix '#'
    case '*'
      set suffix '>'
    end

    switch $prompt_status
    case 0
      set fg_status $color_success[1]
      set bg_status $color_success[2]
      case '*'
      set fg_status $color_fail[1]
      set bg_status $color_fail[2]
    end

    set git_branch (command git rev-parse --abbrev-ref @ ^ /dev/null)

    echo
    echo -s -n (set_color $fg_status -b $bg_status) ' ' $prompt_status ' '
    echo -s -n (set_color $fg_host -b $bg_host) ' ' "$USER" @ "$__fish_prompt_hostname" ' '
    echo -s -n (set_color $fg_pwd -b $bg_pwd) ' ' (prompt_pwd) ' '
    if test $git_branch -a (command git rev-parse --is-inside-work-tree 2> /dev/null) = 'true'
      set fg_git_base_color (set_color $fg_pwd)
      set fg_git_check_add (set_color $fg_git_add)
      set fg_git_check_modify (set_color $fg_git_modify)
      set fg_git_check_unknown (set_color $fg_git_unknown)

      set git_check (command git status --short ^ /dev/null | command awk "
      {
        status[substr(\$0, 1, 2)] += 1
      }
      END {
        for (s in status) {
          if (substr(s, 1, 1) == \" \") {
            printf \"$fg_git_check_modify%s$fg_git_base_color:%d \", substr(s, 2, 1), status[s]
          } else if (substr(s, 2, 1) == \" \") {
            printf \"$fg_git_check_add%s$fg_git_base_color:%d \", substr(s, 1, 1), status[s]
          } else {
            printf \"$fg_git_check_unknown%s$fg_git_base_color:%d \", s, status[s]
          }
        }
      }
      ")
      if test "$git_check"
        set fg_git $fg_git_fail
      else
        set fg_git $fg_git_success
      end
      echo -s -n '| (' (set_color $fg_git) $git_branch (set_color $fg_pwd) ') ' $git_check (set_color $fg_pwd)
    end
    echo -s (set_color normal)
    echo -s -n (set_color $fg_prompt -b $bg_prompt) ' ' $suffix ' ' (set_color normal) ' '
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
  alias less 'less -r'
  alias vim 'vim -p'

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
  alias gpst 'gps --tags'
  alias gpl 'git pull'
  alias gf 'git fetch'
  alias gm 'git merge'
  alias gdiff 'git diff HEAD'
  alias gcl 'git clone --recursive'
  alias ginit 'git init'
  alias glog 'git log --graph --decorate --oneline'
  alias greset 'git reset'
  alias grm 'git rm'
  alias gco 'git checkout'
  alias gcob 'gco -b'
  alias gtag 'git tag'
  alias gremote 'git remote'
  alias gmv 'git mv'
  alias gbr 'git branch'
  alias gbrd 'gbr -d'
  alias gbrm 'gbr -m'

end
