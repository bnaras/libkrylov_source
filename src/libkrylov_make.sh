#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov make script: libkrylov_make.sh'
  echo 'Usage:'
  echo 'This is a script to wrap "make" commands'
  echo 'required to make a library available in libkrylov'
  echo 'placing them in the correct order to correctly'
  echo 'link the correct .o files to each other'
  echo 'based on options chosen when '
  echo 'libkrylov_quickstart.sh was run.' 
  exit 0
fi
echo 'This script works only if particular library has been compiled'
echo ' by libkrylov_quickstart.sh in directory ../.'
# look for user config file
FILE=userlibraryconfig
if [ -f "$FILE" ]; then
  ./libkrylov_make_interactive.sh < $FILE
else
  echo ' Run libkrylov_quickstart to get meaningful output'
fi
