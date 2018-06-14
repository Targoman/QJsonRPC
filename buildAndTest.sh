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

BuildType=$1
BuildCriteria=$2
BaseOutput=$3


function showHappy(){
    echo -e "\n\e[32m[$(date +"%Y/%m/%d %H:%M:%S")]: $@\e[39m\n"
}
function showError(){
    echo -e "\n\e[31m[$(date +"%Y/%m/%d %H:%M:%S")]: $@\e[39m\n"
}
function showWarn(){
    echo -e "\n\e[33m[$(date +"%Y/%m/%d %H:%M:%S")]: $@\e[39m\n"
}
function showInfo(){
    echo -e "\n\e[36m[$(date +"%Y/%m/%d %H:%M:%S")]: $@\e[39m\n"
}

if [ "$BuildType" == "full" ] && [ -z "$BaseOutput" ]; then
    showError "third parameter as PREFIX is obligatory when building in full mode"
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
    showError "!!!!!!!!!!!!!!!!! QMake version 5 is needed to compile the project! !!!!!!!!!!!!!!!!"
    exit 1
  fi
fi

showInfo "Using $QMAKE_COMMAND and $N_CORES_TO_USE processing cores for build ..."

if [ -n "$3" ]; then
    BaseOutput=$3
else
    path=$(realpath -s `pwd`)
    while [[ $path != / ]]; do
        if [ -f "$path/Project.pri" ]; then
            BaseOutput=$path/out
        else
            break
        fi
        path="$(realpath -s "$path"/..)"
    done
fi

mkdir -p $BaseOutput
showInfo "Base Output Path will be $BaseOutput"

function installTargomanProject(){
    pushd $1 && \
    if [ -z "$BuildType" ];then FirstArg="NULL"; else FirstArg="$BuildType"; fi && \
    if [ -z "$BuildCriteria" ];then SecondArg="NULL"; else SecondArg="$BuildCriteria"; fi && \
    ./buildAndTest.sh $FirstArg $SecondArg "$BaseOutput" && \
    make install && \
    popd
}

if [ -f ".gitmodules" ]; then
    showInfo "Building SubModules"
    SubModules=$(cat .gitmodules | grep "\[submodule" | cut -d "\"" -f 2)
    for Module in $SubModules; do
        installTargomanProject $Module
    done
fi


if [ $? -ne 0 ]; then
   exit
fi

showInfo "Building Module"
#TODO -Werror

if [ "$BuildCriteria" != "release" ] ; then
  QMAKE_CONFIG="CONFIG+=debug CONFIG+=WITH_QJsonRPC PREFIX=$BaseOutput"
elif [ "$BuildCriteria" != "distclean" ] ; then
  QMAKE_CONFIG="CONFIG+=WITH_QJsonRPC PREFIX=$BaseOutput"
else
  QMAKE_CONFIG="CONFIG+=WITH_QJsonRPC PREFIX=$BaseOutput"
fi

if [ "$BuildType" == "full" ]; then
    showInfo "Building in full Mode with: $QMAKE_COMMAND $QMAKE_CONFIG"
    rm -rf out
    rm -f `find ./ -name 'Makefile*'`
    mkdir -p out
    if [ -f *.pro ]; then
        $QMAKE_COMMAND $QMAKE_CONFIG
    fi
    make -j $N_CORES_TO_USE
    if [ $? -ne 0 ];then
        showError "!!!!!!!!!!!!!!!!! Build Has failed!!!!!!!!!!!!!!!!"
        exit 1;
    else
        showHappy "Module Compiled Successfully"
        if [ "$BuildCriteria" == "test" ];then
            export LD_LIBRARY_PATH="$BaseOutput/lib"
            TestProgram=$(echo $BaseOutput/unitTest/unitTest_)
            if [ -f  "$TestProgram" ]; then
                eval "$TestProgram"
                if [ $? -ne 0 ]; then
                    showError "!!!!!!!!!!!!!!!!Testing Failed!!!!!!!!!!!!!!!!"
                    exit 0
                else
                    showHappy "Testing Finished Successfully :)"
                fi
            fi
        fi
    fi
elif [ "$BuildType" == "distclean" ]; then
    showInfo "cleaning project with: $QMAKE_COMMAND $QMAKE_CONFIG"
    rm -rf "$BaseOutput"
    make distclean
    rm -rvf `find ./ -name MakeFile`
    rm -rvf `find ./ -name out`
    showHappy "Module Distcleaned Successfully"
else
    showInfo "Building incremental with: $QMAKE_COMMAND $QMAKE_CONFIG"
    mkdir -p out
    $QMAKE_COMMAND $QMAKE_CONFIG
    make -j $N_CORES_TO_USE
    if [ $? -ne 0 ];then
        showError "!!!!!!!!!!!!!!!!! Build Has failed!!!!!!!!!!!!!!!!"
        exit 1;
    else
        showHappy "Module Compiled Successfully"
    fi
fi



popd

