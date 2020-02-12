#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov clean script: libkrylov_clean.sh'
  echo 'Usage:'
  echo 'This is a script to wrap "make" commands'
  echo 'to clean out all compiled files'
  exit 0
fi
echo 'Clean script for every library in libkrylov'
make clean
make uninstall
rm *.mod
rm *_mods/*.mod
rm *_mods/*.o
echo '----------Cleaned out compiled files----------'
