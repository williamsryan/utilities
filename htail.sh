#!/bin/sh

usage() {
  echo "Usage: $0 -f [file] -n [offset]";
  echo "";
  echo "[file] : File to follow"
  echo "[offset] : Range to highlight, rest will be formatted by default";
  echo "";
  exit 1
}

# Formatting variables.
bold=$(tput bold)
normal=$(tput sgr0)

followFile() {
	# Syntax highlight tail logging.
	inputFile=$1
	numOffset=$2

	tail -f $inputFile | awk -v fileVar="$inputFile" -v offset="$numOffset" '
	  BEGIN {
	    print "Following: " fileVar
	    print "Offset: " offset
	  }

	  /INFO/ {
	    for(i=1; i<=offset; i++) {printf "%s ", "\033[32m" $i "\033[39m"}
	    for(j=offset+1; j<=NF; j++) {printf "%s ", $j}
	    print ""
	  }
	  /DEBUG/ {
	    for(i=1; i<=offset; i++) {printf "%s ", "\033[36m" $i "\033[39m"}
	    for(j=offset+1; j<=NF; j++) {printf "%s ", $j}
	    print ""
	  }
	  /ERROR/ {
	    for(i=1; i<=offset; i++) {printf "%s ", "\033[31m" $i "\033[39m"}
	    for(j=offset+1; j<=NF; j++) {printf "%s ", $j}
	    print ""
	  }
	'
}

if [ "$#" -le 1 ]; then
  usage
fi

while [ "$1" != "" ]; do
  case $1 in
      -h|--help)
	usage
	;;
      -f) 
        FILE=$2
        shift
        ;;  
      -n) 
        OFFSET=$2
        shift
        # Specify number of columns to highlight
        # Makes script more verbose
        ;;  
      *)  
        break
        ;;  
  esac
  shift
done

# Run with given params.
followFile $FILE $OFFSET
