#bin/bash
#this script runs all the unit tests and reference drivers
# in their install directory,
#comparing output to references
# NOTE THAT ALL LIBRARIES MUST BE INSTALLED TO EFFECTIVELY
# TEST ALL OF THEM
# run ./ make_all.sh in libkrylov/src/
# to make all libraries
#
echo '~libkrylov test suite run~'
echo 'This tests everything, overwriting all old results!'
echo 'Preparing test directories'
mkdir real_sp_testing.results 2>/dev/null
cp -r real_sp_ref/* real_sp_testing.results/.
mkdir real_dp_testing.results 2>/dev/null
cp -r real_dp_ref/* real_dp_testing.results/.
mkdir cmplx_sp_testing.results 2>/dev/null
cp -r cmplx_sp_ref/* cmplx_sp_testing.results/.
mkdir cmplx_dp_testing.results 2>/dev/null
cp -r cmplx_dp_ref/* cmplx_dp_testing.results/.
echo 'Begin test'
echo 'test results in test/*_testing.results/testing.summary'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cd real_sp_testing.results
./test_script.sh
echo '~moving on to next type(base) and precision test~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cd ../real_dp_testing.results
./test_script.sh
echo '~moving on to next type(base) and precision test~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cd ../cmplx_sp_testing.results
./test_script.sh
echo '~moving on to next type(base) and precision test~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cd ../cmplx_dp_testing.results
./test_script.sh
echo '~All tests done~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cd ..
echo ~grep of all failed statements in testing.summary~
grep -H -B4 'failed' *_testing.results/testing.summary
echo ~~~~~Testing done~~~~~
