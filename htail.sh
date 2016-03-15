#!/usr/bin/sh

# Formatting variables.
bold=$(tput bold)
normal=$(tput sgr0)

# Syntax highlight tail logging.
tail -f $1 | awk '
  /INFO/ {print "\033[32m" $0 "\033[39m"}
  /DEBUG/ {print "\033[36m" $0 "\033[39m"}
  /ERROR/ {print "\033[31m" $0 "\033[39m" ; next}
'

1{print}
