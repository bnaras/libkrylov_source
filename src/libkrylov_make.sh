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
echo 'Following options chosen during libkrylov_quickstart.sh'
echo ' Run libkrylov_quickstart to generate userlibraryconfig if missing'
# use userinput to make a library
./libkrylov_make_interactive.sh < userlibraryconfig

