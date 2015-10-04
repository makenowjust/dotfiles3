function prepend_env --argument name path
  if test -d "$path"
    set -gx $name $path $$name
  end
end

function append_env --argument name path
  if test -d "$path"
    set -gx $name $$name $path
  end
end

function fix_env --argument name
  set -gx $name (printenv $name | sed 's/\x1e/:/g')
end

# MANPATHは:が1つ多くないと、システムのmanを読み込めなくなる
set -x MANPATH :

# linuxbrewの設定
prepend_env PATH "$HOME/.linuxbrew/bin"
prepend_env MANPATH "$HOME/.linuxbrew/share/man"
prepend_env INFOPATH "$HOME/.linuxbrew/share/info"
prepend_env LIBRARY_PATH "$HOME/.linuxbrew/lib"
prepend_env LD_LIBRARY_PATH "$HOME/.linuxbrew/lib"

# nodebrewの設定
prepend_env PATH "$HOME/.nodebrew/current/bin"

# cabalの設定
prepend_env PATH ~/.cabal/bin

# torch7の設定
prepend_env LUA_PATH "$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;$HOME/local/share/torch/install/share/lua/5.1/?.lua;$HOME/local/share/torch/install/share/lua/5.1/?/init.lua;./?.lua;$HOME/local/share/torch/install/share/luajit-2.1.0-alpha/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"
prepend_env LUA_CPATH "$HOME/.luarocks/lib/lua/5.1/?.so;$HOME/local/share/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so"
prepend_env PATH "$HOME/local/share/torch/install/bin"
prepend_env LD_LIBRARY_PATH "$HOME/local/share/torch/install/lib"
prepend_env DYLD_LIBRARY_PATH "$HOME/local/share/torch/install/lib"

# HOME直下のlocalを設定
prepend_env PATH ~/local/bin
prepend_env MANPATH ~/local/share/man
prepend_env LIBRARY_PATH ~/local/lib
prepend_env LD_LIBRARY_PATH ~/local/lib

fix_env LIBRARY_PATH
fix_env LD_LIBRARY_PATH
fix_env DYLD_LIBRARY_PATH
