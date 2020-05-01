#bin/bash
#this script runs all the unit tests and reference drivers
#
echo '~libkrylov test suite clean up~'
echo 'Deleting test directories'
rm -rf real_sp_testing.results 2>/dev/null
rm -rf real_dp_testing.results 2>/dev/null
rm -rf cmplx_sp_testing.results 2>/dev/null
rm -rf cmplx_dp_testing.results 2>/dev/null
echo ~~~~~Clean up done~~~~~
