#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov quickstart script: libkrylov_quickstart.sh'
  echo 'Usage:'
  echo 'This script contains the commands to quickly start'
  echo 'using this library by' 
  echo 'doing the following in the libkrylov/src directory:'
  echo '1. checking that programs required for make are present'
  echo '2. running the libkrylov_configure.sh script which'
  echo '       determines the libraries available to the user'
  echo '       runs the autoreconf and configure program to'
  echo '       sets up the correct Makefile'
  echo '3. generates userlibraryconfig based on user input'
  echo '4. running libkrylov_make.sh script which'
  echo '       makes the installation directories'
  echo '       makes the libraries and test programs'
  echo 'then doing the following in the libkrylov/test directory'
  echo '5. running the appropriate test_*.sh script which'
  echo '       runs the test programs for the appropriate library' 
  echo 'DO NOT RUN "make" TO BUILD FILES, IT CANNOT IDENTIFY POLYMORPHISM'
  exit 0
fi
# exit if any step fails
set -e
echo 'Quick start for libkrylov libraries.'
# checking for required programs
if hash make 2>/dev/null; 
then
  echo 'make available'
else
  echo 'ERROR: make not available, exiting'
  exit 1
fi
if hash autoreconf 2>/dev/null;
then
  echo 'autoconf available'
else
  echo 'ERROR: autoconf not available, exiting'
  exit 1
fi
if hash automake 2>/dev/null;
then
  echo 'automake available'
else
  echo 'ERROR: automake not available, exiting'
  exit 1
fi
if hash libtoolize 2>/dev/null;
then
  echo 'libtool available: may be Apple libtool, see next check'
else
  echo 'WARNING: libtool not available: maybe installed as glibtool, see next check'
fi
if hash glibtoolize 2>/dev/null;
then
  echo 'glibtool available'
else
  echo 'WARNING: glibtool not available'
fi
#entering src directory
cd src/
# set $LIBKRYLOV_PATH
export LIBKRYLOV_PATH=$PWD
echo '--------------------------------------------------'
echo 'libraries folders will be installed in '$LIBKRYLOV_PATH
echo '--------------------------------------------------'
# Select configuration, configuring make structure
./libkrylov_configure.sh
# Determing how much of the library to build
echo 'Build all libraries?'
echo ' Please enter >yes< or >no<'
echo ' (Default: >no<)'
read answer2
for (( ; ; ))
do
# set default to making with all libraries to be no
  if [[ $answer2 == "" ]];
  then
    answer2="no"
  fi
  if [[ $answer2 == yes ]];
  then
# goes past all $answer2 == no loop to THIS PLACE
    break
  fi
  if [[ $answer2 == no ]];
  then
# continued outside loop at HERE
    break
  fi
  echo 'please enter an available option'
  read answer2
done
# write to config file, overwriting past
echo $answer2 > userlibraryconfig
if [[ $answer2 == no ]];
then
# continuing for HERE
# determine the desired library
  echo 'Select precision of desired library'
  echo ' Please enter >single< or >double<'
  echo ' (Default: >double<)'
  read precision
  for (( ; ; ))
  do
# set default precision to be double
    if [[ $precision == "" ]];
    then
      precision="double"
    fi
    if [[ $precision == double ]];
    then
      break
    fi
    if [[ $precision == single ]];
    then
      break
    fi
    echo 'please enter an available option'
    read precision
  done
# write to userlibraryconfig file to be used later
  echo $precision >> userlibraryconfig
  echo 'Select element type of desired library'
  echo ' Please enter >real< or >complex<'
  echo ' (Default: >real<)'
  read element_type
  for (( ; ; ))
  do
# set default element type to be real
    if [[ $element_type == "" ]];
    then
      element_type="real"
    fi
    if [[ $element_type == real ]];
    then
      break
    fi
    if [[ $element_type == complex ]];
    then
      break
    fi
    echo 'please enter an available option'
    read element_type
  done
# write to file to be used later
  echo $element_type >> userlibraryconfig
fi
# THIS PLACE
# use userinput to make a library
./libkrylov_make.sh
# leave src directory and go to test directory 
cd ../test/
# clean old tests
./remove_test.sh
# run specified test on library made
./test_script.sh
# return to libkrylov directory
cd ..
echo 'Congratulations on installing libkrylov!'
echo 'The printout above is a summary of testing results,' 
echo 'please see '
echo $PWD'/test/*_testing.results/*'
echo 'for detailed test results.'
echo 'Here are some suggestions for linking the library:'
cat linking_advice.txt
echo 'All the best!'
