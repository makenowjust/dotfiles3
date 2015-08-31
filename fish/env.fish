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

# HOME直下のlocalを設定
prepend_env PATH ~/local/bin
prepend_env MANPATH ~/local/share/man
prepend_env LIBRARY_PATH ~/local/lib
prepend_env LD_LIBRARY_PATH ~/local/lib

# linuxbrewの設定
prepend_env PATH "$HOME/.linuxbrew/bin"
prepend_env MANPATH "$HOME/.linuxbrew/share/man"
prepend_env INFOPATH "$HOME/.linuxbrew/share/info"
prepend_env LIBRARY_PATH "$HOME/.linuxbrew/lib"
prepend_env LD_LIBRARY_PATH "$HOME/.linuxbrew/lib"

# cabalの設定
prepend_env PATH ~/.cabal/bin

fix_env LIBRARY_PATH
fix_env LD_LIBRARY_PATH
