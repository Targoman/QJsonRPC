################################################################################
#   Targoman: A robust Machine Translation framework
#
#   Copyright 2014-2018 by ITRC <http://itrc.ac.ir>
#
#   This file is part of Targoman.
#
#   Targoman is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Targoman is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public License
#   along with Targoman. If not, see <http://www.gnu.org/licenses/>.
################################################################################
#!/bin/bash

pushd $(dirname $0)

if [ $1 == "full" ] && [ -z "$3" ]; then
    echo "third parameter as PREFIX is obligatory when building in full mode"
    exit
fi

N_CORES_TO_USE=$(cat /proc/cpuinfo| grep processor | wc -l)
N_CORES_TO_USE=$((N_CORES_TO_USE - 1))
if [ $N_CORES_TO_USE -lt 1 ]; then
  N_CORES_TO_USE=1
fi

QMAKE_COMMAND=qmake-qt5
if [ -z "$(which $QMAKE_COMMAND 2> /dev/null)" ]; then
  QMAKE_COMMAND=qmake
  if [ -z "$(which $QMAKE_COMMAND 2> /dev/null)" ]; then
    echo -e "\n\e[31m!!!!!!!!!!!!!!!!! QMake version 5 is needed to compile the project! !!!!!!!!!!!!!!!! \e[39m\n"
    exit 1
  fi
fi

echo "Using $QMAKE_COMMAND and $N_CORES_TO_USE processing cores for build ..."

echo "Building SubModules"
mkdir -p out
if [ -z "$3" ]; then
    BaseOutput=$(readlink -f ./out)
else
    BaseOutput=$3
fi

echo "Base Output Path will be $BaseOutput"


function installTargomanProject(){
    pushd $1 && \
    if [ -z "$2" ];then FirstArg="NULL"; else FirstArg="$2"; fi && \
    if [ -z "$3" ];then SecondArg="NULL"; else SecondArg="$3"; fi && \
    ./buildAndTest.sh "$FirstArg" "$SecondArg" "$BaseOutput" && \
    make install && \
    popd
}

echo "Building Module"
#TODO -Werror

BasePath=$BaseOutput
export LD_LIBRARY_PATH="$BasePath/out/lib"
if [ "$2" != "release" ] ; then
  QMAKE_CONFIG="CONFIG+=debug CONFIG+=WITH_QJsonRPC PREFIX=${@:3}"
else
  QMAKE_CONFIG="CONFIG+=WITH_QJsonRPC PREFIX=${@:3}"
fi

if [ "$1" == "full" ]; then
    echo "Building in full Mode with: $QMAKE_COMMAND $QMAKE_CONFIG"
    rm -rf out
    rm -f `find ./ -name 'Makefile*'`
    mkdir -p out/include
    if [ -f *.pro ]; then
        $QMAKE_COMMAND $QMAKE_CONFIG
    fi
    make -j $N_CORES_TO_USE
    if [ $? -ne 0 ];then
        echo -e "\n\e[31m!!!!!!!!!!!!!!!!! Build Has failed!!!!!!!!!!!!!!!! \e[39m\n"
        exit 1;
    else
        echo -e "\n\e[32m Module Compiled Successfully\e[39m\n"
        if [ "$2" == "test" ];then
            TestProgram=$(echo $BasePath/out/unitTest/unitTest_)
            if [ -f  "$TestProgram" ]; then
            eval "$TestProgram"
            if [ $? -ne 0 ]; then
                echo -e "\n\e[31m!!!!!!!!!!!!!!!!Testing Failed!!!!!!!!!!!!!!!! \e[39m\n"
                exit 0
            else
                echo -e "\e[0;34m Testing Finished Successfully :) \e[39m\n"
            fi
            fi
        fi
    fi
else
    echo "Building incremental with: $QMAKE_COMMAND $QMAKE_CONFIG"
    mkdir -p out/include
    $QMAKE_COMMAND $QMAKE_CONFIG
    make -j $N_CORES_TO_USE
    if [ $? -ne 0 ];then
    echo -e "\n\e[31m!!!!!!!!!!!!!!!!! Build Has failed!!!!!!!!!!!!!!!! \e[39m\n"
    exit 1;
    else
    echo -e "\n\e[32m Module Compiled Successfully\e[39m\n"
    fi
fi

#if [ -d "./scripts" ]; then
#    mkdir -p $BaseOutput/scripts
#    for Path in $(ls ./scripts/); do
#    ln -snf $readlink("./scripts/$Path") "./out/scripts/"
#    done
#fi

popd
