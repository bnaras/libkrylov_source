#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov configuration script: configure.sh'
  echo 'This script copies the correct configure scripts and files'
  echo 'and runs them.'
  echo 'Usage:'
  echo 'This script should be used only'
  echo 'first time the library is installed, or'
  echo 'if there is some changes to the dependencies of the library.'
  echo 'do "make_custom.sh --help" to see custom driver installation help.'
  echo 'A fresh git clone is suggested if the BLAS/LAPack dependencies'
  echo 'are to be changed.'
  exit 0
fi
set -e
# Select building with BLAS
echo 'Build with external BLAS/LAPack libraries?'
echo ' Please enter >yes< or >no<'
echo '(default: >yes<)'
echo 'yes'
answer1="yes"
#read answer1
for (( ; ; ))
do
# set default to making with BLAS/LAPACK to be yes
  if [[ $answer1 == "" ]];
  then
    answer1="yes"
  fi
  if [[ $answer1 == yes ]];
  then
    echo 'Build special options with intel MKL BLAS/LAPack libraries ?'
    echo ' Please enter >yes< or >no<'
    echo '(default: >no<)'
    read answer2
    for (( ; ; ))
    do
# set default to making with mkl to be yes
      if [[ $answer2 == "" ]];
      then
        answer2="no"
      fi
      if [[ $answer2 == yes ]];
      then
        echo 'Linking MKL found on $LD_LIBRARY_PATH'
        echo 'present $LD_LIBRARY_PATH is'
        echo $LD_LIBRARY_PATH
        path_addition=$LD_LIBRARY_PATH
        for (( ; ; ))
        do
          if [[ $path_addition == "" ]];
          then
            echo '$LD_LIBRARY_PATH is empty'
            echo 'A path to the MKL installation must be entered.'
            echo '(Otherwise, Ctrl+c to terminate bash)'
            read path_addition
          else
            break
          fi        
        done
        export LDFLAGS=$LDFLAGS' -L'$path_addition
        echo 'present $LDFLAGS is'
        echo $LDFLAGS
        cp configure_mkl configure
        cp configure_blas_free.ac configure.ac
#        cp libtool_blas_free libtool
        cp Makefile_mkl.am Makefile.am
        cp Makefile_mkl.in Makefile.in
        echo '----------copied MKL configure file----------'
        ./configure --help
        ./configure --prefix=$PWD
        echo '----------configure done----------'
        break
      fi
      if [[ $answer2 == no ]];
      then
        cp configure_blas configure
        cp configure_blas.ac configure.ac
#        cp libtool_blas libtool
        cp Makefile_blas.am Makefile.am
        cp Makefile_blas.in Makefile.in
        echo '----------copied BLAS/LAPack configure files----------'
        echo 'Any suggestions on where your BLAS might be?'
        echo '(Optional, can be used to point to a specific library)'
        read answer3
        echo 'Any suggestions on where your LAPack might be?'
        echo '(Optional, can be used to point to a specific library)'
        read answer4
        ./configure --help
        ./configure --prefix=$PWD --with-blas=$answer3 --with-lapack=$answer4
        echo '----------configure done----------'
        break
      fi
      echo 'please enter an available option'
      read answer2
    done
    break
  fi
  if [[ $answer1 == no ]];
  then
    echo 'blas-free not implemented yet!'
    exit 1
    cp configure_blas_free configure
    cp configure_blas_free.ac configure.ac
#    cp libtool_blas_free libtool
    cp Makefile_blas_free.am Makefile.am
    cp Makefile_blas_free.in Makefile.in
    echo '----------copied BLAS-free configure files----------'
    ./configure --help
    ./configure --prefix=$PWD
    echo '----------configure done----------'
    break
  fi
  echo 'please enter an available option'
  read answer1
done
