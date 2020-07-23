#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov configuration script: libkrylov_configure.sh'
  echo 'This script copies the correct configure scripts and files'
  echo 'and runs them.'
  echo 'Usage:'
  echo 'This script should be used only'
  echo 'first time the library is installed, or'
  echo 'if there is some changes to the dependencies of the library.'
  echo 'A fresh git clone is suggested if the BLAS/LAPack dependencies'
  echo 'are to be changed.'
  exit 0
fi
set -e
# set autoconf-archive macro path
echo 'Finding an installation of autoconf-archive macros'
echo 'if not installed, please Ctrl+c, find a path you like and enter:'
echo 'git clone --depth 1 --branch v2019.01.06 https://github.com/autoconf-archive/autoconf-archive.git'
echo 'Please enter a file path to your autoconf archive macros'
echo 'which usually look like "/a/path/like/autoconf-archive/m4" :'
read autoconf_path
for (( ; ; ))
do
  if [[ $autoconf_path == "" ]];
  then
    echo '$AUTOCONF_MACRO is empty'
    echo "A path to the autoconf-archive installation's macro must be entered."
    echo '(Otherwise, Ctrl+c to terminate bash)'
    read autoconf_path
  else
    break
  fi        
done
AUTOCONF_MACRO=$autoconf_path
echo '$AUTOCONF_MACRO entered is'
echo $AUTOCONF_MACRO
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
# set default to making with mkl to be no
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
# generate Makefile.am
        echo ''
        echo 'generating Makefile.am from templates'
        sed "s|Placeholder|$AUTOCONF_MACRO|g" Makefile_shared.am > Makefile.am
        cat Makefile_mkl_template.am >> Makefile.am
# copy configure.ac without blas/lapack searches
        echo 'generating configure.ac from template'
        sed "s|Placeholder|$AUTOCONF_MACRO|g" configure_blas_free.ac > configure.ac
        echo '----------copied MKL autoconf files----------'
        autoreconf --verbose --install --force -I $AUTOCONF_MACRO
        echo '----------autoconf for MKL done----------'
        ./configure --prefix=$PWD
        break
      fi
      if [[ $answer2 == no ]];
      then
# generate Makefile.am
        echo 'generating Makefile.am from templates'
        sed "s|Placeholder|$AUTOCONF_MACRO|g" Makefile_shared.am > Makefile.am
        cat Makefile_blas_template.am >> Makefile.am
# copy configure.ac without blas/lapack searches
        echo 'generating configure.ac from template'
        sed "s|Placeholder|$AUTOCONF_MACRO|g" configure_blas.ac > configure.ac
        echo '----------copied BLAS/LAPack configure files----------'
        autoreconf --verbose --install --force -I $AUTOCONF_MACRO
        echo '----------autoconf for external BLAS/LAPack library done----------'
        echo 'Please enter a desired BLAS library file path'
        echo '(Optional, can be used to point to a specific library)'
        read answer3
        echo 'Please enter a LAPack library file path'
        echo '(Optional, can be used to point to a specific library)'
        read answer4
        ./configure --prefix=$PWD --with-blas=$answer3 --with-lapack=$answer4
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
# generate Makefile.am
    echo 'generating Makefile.am from templates'
    sed "s|Placeholder|$AUTOCONF_MACRO|g" Makefile_shared.am > Makefile.am
    cat Makefile_blas_free_template.am >> Makefile.am
# copy configure.ac without blas/lapack searches
    echo 'generating configure.ac from template'
    sed "s|Placeholder|$AUTOCONF_MACRO|g" configure_blas_free.ac > configure.ac
    echo '----------copied external-library-free autoconf files----------'
    autoreconf --verbose --install --force -I $AUTOCONF_MACRO
    echo '----------autoconf without external library done----------'
    ./configure --help
    ./configure --prefix=$PWD
    break
  fi
  echo 'please enter an available option'
  read answer1
done
echo '----------configure done----------'
