#bin/bash
#this script runs all the unit tests and reference drivers
#
echo '~libkrylov test suite clean up~'
echo 'Deleting test directories'
rm -r real_sp_testing.results
rm -r real_dp_testing.results
rm -r cmplx_sp_testing.results
rm -r cmplx_dp_testing.results
echo ~~~~~Clean up done~~~~~
