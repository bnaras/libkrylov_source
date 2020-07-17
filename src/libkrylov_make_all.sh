#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov make all script: make_all.sh'
  echo 'Usage:'
  echo 'This is a script to wrap "make" commands'
  echo 'required to make all libraries available'
  echo 'placing them in the correct order to correctly'
  echo 'link the correct .o files to each other'
  exit 0
fi
set -e
echo 'Make script for every library in libkrylov'
# this command only makes sense for making everything
make installdirs
./libkrylov_make_interactive.sh << ENDINPUT
no
single
real
ENDINPUT
./libkrylov_make_interactive.sh << ENDINPUT
no
double
real
ENDINPUT
./libkrylov_make_interactive.sh << ENDINPUT
no
single
complex
ENDINPUT
./libkrylov_make_interactive.sh << ENDINPUT
no
double
complex
ENDINPUT
echo '----------All make instructions completed----------'
echo 'Please test your libraries in libkrylov/test/'
echo 'by calling ./test_script.sh'
cat ../linking_advice.txt
