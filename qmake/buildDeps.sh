#!/bin/bash

ExternalDeps=$3
DEPS_BUILT=$(realpath $(dirname $2))/$(basename $2)
cd $(realpath $1)
BASE_PATH=$(pwd)

CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l)
CPU_COUNT=$((CPU_COUNT-1))

QMAKE_CLI=qmake-qt5
if ! which $QMAKE_CLI >/dev/null 2>&1; then
    QMAKE_CLI=qmake
    if ! which $QMAKE_CLI >/dev/null 2>&1; then
        echo "Error finding the `qmake` command." 1>&2
        exit 1
    fi
fi

echo "Using $QMAKE_CLI ..."

if ! grep "Using Qt version 5." <<< $($QMAKE_CLI -v) >/dev/null 2>&1; then
    echo "Qt version 5.x is needed for compiling this library." 1>&2
    exit 1
fi

mkdir -p $BASE_PATH/out

if [ -f .gitmodules ]; then
  Deps=$(grep "\[submodule " .gitmodules | cut -d ' ' -f 2 | tr -d '\"\]')
  for Dep in $Deps; do
    echo -e "\n\n=====================> Building $Dep <========================\n"
    if [ $ExternalDeps -eq 1 ]; then
      echo -e "Target building ignored as must be used as external\n"
      continue
    fi
    if  fgrep "$Dep" "$DEPS_BUILT" >/dev/null 2>&1; then
        echo "Target has already been built."
        continue
    fi
    pushd $Dep
      if [ -r *".pro" ]; then
          make distclean
          $QMAKE_CLI PREFIX=$BASE_PATH/out
          make install -j $CPU_COUNT
          if [ $? -ne 0 ]; then
            echo "Error building qmake project"
            exit 1
          fi
      elif [ -r "CMakeLists.txt" ];then
          mkdir -p buildForProject
          pushd buildForProject
            cmake -DCMAKE_INSTALL_PREFIX:PATH=$BASE_PATH/out ..
            make install -j $CPU_COUNT
            if [ $? -ne 0 ]; then
                echo "Error building qmake project"
                exit 1
            fi
          popd
      else
        echo -e "\n\n[WARNING] Project: $Dep type could not be determined so will not be compiled\n\n"
      fi
      echo "echo $Dep >> $DEPS_BUILT"
      echo $Dep >> $DEPS_BUILT
    popd
  done
fi 
