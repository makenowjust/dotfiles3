# NAME
#   take - mkdir + cd
#
# SYNOPSIS
#   take DIR ...
#
# DESCRIPTION
#   It makes directory named DIR and set current directory as DIR one by one.
#   In other words, `take a; take b' is equivent to `take a b'.
#
# AUTHORS
#   TSUYUSATO Kitsune <make.just.on@gmail.com>
#/
function take -d "take = mkdir + cd"
  for path in $argv
    mkdir -p $path; and cd $path
  end
end
