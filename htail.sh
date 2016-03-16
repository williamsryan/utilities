#!/usr/bin/sh

# Formatting variables.
bold=$(tput bold)
normal=$(tput sgr0)
inputFile=$1

# Syntax highlight tail logging.
tail -f $inputFile | awk -v fileVar="$inputFile" '
  BEGIN {
    print "Following: " fileVar
  }

  /INFO/ {
  	print "\033[32m" $1, $2, $3, $4, $5 "\033[39m"
  	printf "%s\t", ""
  	for(i=6; i<=NF; i++) {printf "%s ", $i}
  	print ""
  }
  /DEBUG/ {
  	print "\033[36m" $1, $2, $3, $4, $5 "\033[39m"
  	printf "%s\t", ""
  	for(i=6; i<=NF; i++) {printf "%s ", $i}
  	print ""
  }
  /ERROR/ {
  	print "\033[31m" $1, $2, $3, $4, $5 "\033[39m"
  	printf "%s\t", ""
  	for(i=6; i<=NF; i++) {printf "%s ", $i}
  	print ""
  }
'
