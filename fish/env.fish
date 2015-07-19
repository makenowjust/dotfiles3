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

# HOME直下のlocalを設定
prepend_path ~/local/bin
set -gx MANPATH ":~/local/share/man"
set -gx LIBRARY_PATH ~/local/lib
set -gx LD_LIBRARY_PATH ~/local/lib

# vvm(https://github.com/kana/vim-version-manager)の設定
prepend_path ~/.vvm/bin
prepend_path ~/.vvm/vims/current/bin

