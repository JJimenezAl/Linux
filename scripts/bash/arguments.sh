#!/bin/bash

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments with \$@: $@"
echo "All arguments with \$*: $*"
echo "Arguments count: $#"
echo "Process ID: $$"
echo "Shell name or command $_"
echo "$-"

#$1 is the first argument
# $2 is the second argument
# $n is the nth argument
# "$@" expands as "$1" "$2" "$3" and so on
# "$*" expands as "$1c$2c$3", where c is the first character of IFS
# "$@" is the most used one. "$*" is used rarely since it gives all arguments as a
# single string.