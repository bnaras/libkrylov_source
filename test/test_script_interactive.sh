#bin/bash
#this script runs unit tests and reference drivers
# specified by the user,
# in their install directory,
#comparing output to references
# NOTE THAT A LIBRARY MUST BE INSTALLED TO EFFECTIVELY
# TEST IT
# run ./make_interactive.sh in libkrylov/src/
# to make that specific library
#
echo '~libkrylov test suite run~'
echo 'This tests a specific library, overwriting all old results'
echo "of that library's previous test"
echo 'Select precision of desired library to test'
echo '  Please enter >single< or >double<'
read precision
for (( ; ; ))
do
  if [[ $precision == single ]];
  then
    break
  fi
  if [[ $precision == double ]];
  then
    break
  fi
  echo 'please enter an available option' 
  read precision
done
echo 'Select element type of desired library'
echo ' Please enter >real< or >complex<'
read element_type
for (( ; ; ))
do
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
echo 'Precision is ' $precision
echo 'Element type is ' $element_type
echo 'Preparing test directories'
if [[ $precision == single && $element_type == real ]];
then
  mkdir real_sp_testing.results 2>/dev/null
  cp -r real_sp_ref/* real_sp_testing.results/.
  echo 'Begin test'
  echo 'Test summary in test/real_sp_testing.results/testing.summary'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  cd real_sp_testing.results
fi
if [[ $precision == single && $element_type == complex ]];
then
  mkdir cmplx_sp_testing.results 2>/dev/null
  cp -r cmplx_sp_ref/* cmplx_sp_testing.results/.
  echo 'Begin test'
  echo 'Test summary in test/cmplx_sp_testing.results/testing.summary'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  cd cmplx_sp_testing.results
fi
if [[ $precision == double && $element_type == real ]];
then
  mkdir real_dp_testing.results 2>/dev/null
  cp -r real_dp_ref/* real_dp_testing.results/.
  echo 'Begin test'
  echo 'Test summary in test/real_dp_testing.results/testing.summary'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  cd real_dp_testing.results
fi
if [[ $precision == double && $element_type == complex ]];
then
  mkdir cmplx_dp_testing.results 2>/dev/null
  cp -r cmplx_dp_ref/* cmplx_dp_testing.results/.
  echo 'Begin test'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  echo 'Test summary in test/cmplx_dp_testing.results/testing.summary'
  cd cmplx_dp_testing.results
fi
./test_script.sh
echo '~All tests done~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo ~grep of all failed statements in testing.summary~
grep -B4 'failed' testing.summary
cd ..
echo ~~~~~Testing done~~~~~
