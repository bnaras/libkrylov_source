#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov clean script: libkrylov_clean.sh'
  echo 'Usage:'
  echo 'This is a script to ensure mod files are cleaned'
  exit 0
fi
echo 'Clean script for src in libkrylov'
make clean
rm *.mod
echo '----------Cleaned out files----------'
