#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov interactive make script: libkrylov_make_interactive.sh'
  echo 'Usage:'
  echo 'This is a script to wrap "make" commands'
  echo 'required to make a library available in libkrylov'
  echo 'placing them in the correct order to correctly'
  echo 'link the correct .o/.mod files to each other'
  exit 0
fi
set -e
echo 'Make for a libkrylov library'
echo 'Beginning with a clean:'
./libkrylov_clean.sh
echo '----------Cleaned out temporary files----------'
echo 'Select all libraries?'
echo '  Please enter >yes< or >no<'
echo ' (Default: >yes<)'
read answer
for (( ; ; ))
do
# set default to build all libraries
  if [[ $answer == "" ]];
  then
    answer="yes" 
  fi
  if [[ $answer == yes ]];
  then
    ./libkrylov_make_all.sh
    break
  fi
  if [[ $answer == no ]];
  then
    break
  fi
  echo 'please enter an available option' 
  read answer
done
if [[ $answer == no ]];
then
  echo 'Select precision of desired library'
  echo '  Please enter >single< or >double<'
  echo ' (Default: >double<)'
  read precision
  for (( ; ; ))
  do
  # set default precision to be double
    if [[ $precision == "" ]];
    then
      precision="double" 
    fi
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
  echo 'Precision is ' $precision
  echo 'Element type is ' $element_type
  if [[ $precision == single && $element_type == real ]];
  then
    make install-real_sp_libLTLIBRARIES
    echo '----------Real Single Precision Library done----------'
    make install-real_sp_arrayfilePROGRAMS
    make install-real_sp_basetypePROGRAMS
    make install-real_sp_blastypePROGRAMS
    make install-real_sp_ritzPROGRAMS
    make install-real_sp_krylovintrfcPROGRAMS
    make install-real_sp_normsPROGRAMS
    echo '----------Real Single Precision unit-tests made----------'
    make install-real_sp_restartPROGRAMS
    echo '----------Real Single Precision utility programs made----------'
    make install-real_sp_driver1aPROGRAMS
    make install-real_sp_driver1bPROGRAMS
    make install-real_sp_driver1cPROGRAMS
    echo '----------Real Single Precision driver1 made----------'
    make install-real_sp_sym_problem1PROGRAMS
    echo '----------Real Single Precision reference problems made----------'
    cp *.mod real_sp_mods/.
    cp *.o real_sp_mods/.
    cp libkrylovinterface_real_sp.mod ../lib/.
    cp libkrylovinterface_real_sp.o ../lib/.
    cp libkrylovsolver_real_sp.mod ../lib/.
    cp libkrylovsolver_real_sp.o ../lib/.
    echo '----------Real Single Precision done----------'
  fi
  if [[ $precision == single && $element_type == complex ]];
  then
    make install-cmplx_sp_libLTLIBRARIES
    echo '----------Complex Single Precision Library done----------'
    make install-cmplx_sp_arrayfilePROGRAMS
    make install-cmplx_sp_basetypePROGRAMS
    make install-cmplx_sp_blastypePROGRAMS
    make install-cmplx_sp_ritzPROGRAMS
    make install-cmplx_sp_krylovintrfcPROGRAMS
    make install-cmplx_sp_normsPROGRAMS
    echo '----------Complex Single Precision unit-tests made----------'
    make install-cmplx_sp_restartPROGRAMS
    echo '----------Complex Single Precision utility programs made----------'
    make install-cmplx_sp_driver1aPROGRAMS
    make install-cmplx_sp_driver1bPROGRAMS
    make install-cmplx_sp_driver1cPROGRAMS
    echo '----------Complex Single Precision driver1 made----------'
    make install-cmplx_sp_sym_problem1PROGRAMS
    echo '----------Complex Single Precision reference problems made----------'
    cp *.mod cmplx_sp_mods/.
    cp *.o cmplx_sp_mods/.
    cp libkrylovinterface_cmplx_sp.mod ../lib/.
    cp libkrylovinterface_cmplx_sp.o ../lib/.
    cp libkrylovsolver_cmplx_sp.mod ../lib/.
    cp libkrylovsolver_cmplx_sp.o ../lib/.
    echo '----------Complex Single Precision done----------'
  fi
  if [[ $precision == double && $element_type == real ]];
  then
    make install-real_dp_libLTLIBRARIES
    echo '----------Real Double Precision Library done----------'
    make install-real_dp_arrayfilePROGRAMS
    make install-real_dp_basetypePROGRAMS
    make install-real_dp_blastypePROGRAMS
    make install-real_dp_ritzPROGRAMS
    make install-real_dp_krylovintrfcPROGRAMS
    make install-real_dp_normsPROGRAMS
    echo '----------Real Double Precision unit-tests made----------'
    make install-real_dp_restartPROGRAMS
    echo '----------Real Double Precision utility programs made----------'
    make install-real_dp_driver1aPROGRAMS
    make install-real_dp_driver1bPROGRAMS
    make install-real_dp_driver1cPROGRAMS
    echo '----------Real Double Precision driver1 made----------'
    make install-real_dp_sym_problem1PROGRAMS
    echo '----------Real Double Precision reference problems made----------'
    cp *.mod real_dp_mods/.
    cp *.o real_dp_mods/.
    cp libkrylovinterface_real_dp.mod ../lib/.
    cp libkrylovinterface_real_dp.o ../lib/.
    cp libkrylovsolver_real_dp.mod ../lib/.
    cp libkrylovsolver_real_dp.o ../lib/.
    echo '----------Real Double Precision done----------'
  fi
  if [[ $precision == double && $element_type == complex ]];
  then
    make install-cmplx_dp_libLTLIBRARIES
    echo '----------Complex Double Precision Library done----------'
    make install-cmplx_dp_arrayfilePROGRAMS
    make install-cmplx_dp_basetypePROGRAMS
    make install-cmplx_dp_blastypePROGRAMS
    make install-cmplx_dp_ritzPROGRAMS
    make install-cmplx_dp_krylovintrfcPROGRAMS
    make install-cmplx_dp_normsPROGRAMS
    echo '----------Complex Double Precision unit-tests made----------'
    make install-cmplx_dp_restartPROGRAMS
    echo '----------Complex Double Precision utility programs made----------'
    make install-cmplx_dp_driver1aPROGRAMS
    make install-cmplx_dp_driver1bPROGRAMS
    make install-cmplx_dp_driver1cPROGRAMS
    echo '----------Complex Double Precision driver1a made----------'
    make install-cmplx_dp_sym_problem1PROGRAMS
    echo '----------Complex Double Precision reference problems made----------'
    cp *.mod cmplx_dp_mods/.
    cp *.o cmplx_dp_mods/.
    cp libkrylovinterface_cmplx_dp.mod ../lib/.
    cp libkrylovinterface_cmplx_dp.o ../lib/.
    cp libkrylovsolver_cmplx_dp.mod ../lib/.
    cp libkrylovsolver_cmplx_dp.o ../lib/.
    echo '----------Complex Double Precision done----------'
  fi
  echo '----------All make instructions completed----------'
  echo 'Please test your library in libkrylov/test/'
  echo 'by calling ./test_script_interactive.sh'
  cat ../linking_advice.txt
fi
