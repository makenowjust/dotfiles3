function prepend_path
  for path in $argv
    if test -d "$path"
      set PATH $path $PATH
    end
  end
end

function append_path
  for path in $argv
    if test -d "$path"
      set PATH $PATH $path
    end
  end
end

# vvm(https://github.com/kana/vim-version-manager)の設定
prepend_path ~/.vvm/bin
prepend_path ~/.vvm/vims/current/bin
