#bin/bash
echo 'This script works only if particular library has been compiled'
echo ' by libkrylov_quickstart.sh in directory ../.'
# look for user config file
FILE=../src/userlibraryconfig
if [ -f "$FILE" ]; then
  ./test_script_interactive.sh < $FILE
else
  echo ' Run libkrylov_quickstart to get meaningful output'
fi
