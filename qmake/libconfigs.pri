################################################################################
#   TargomanBuildSystem
#
#   Copyright 2010-2021 by Targoman Intelligent Processing <http://tip.co.ir>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
################################################################################
include (./configs.pri)

TEMPLATE = lib
defined(LibName): TARGET = $$LibName
!defined(LibName): TARGET = $$ProjectName

DESTDIR      = $$BaseLibraryFolder
MOC_DIR      = $$BaseBuildFolder/moc
OBJECTS_DIR  = $$BaseBuildFolder/obj
RCC_DIR      = $$BaseBuildFolder/rcc
UI_DIR       = $$BaseBuildFolder/ui

QMAKE_CXXFLAGS_RELEASE += -fPIC
QMAKE_CXXFLAGS_DEBUG += -fPIC

INCLUDEPATH+=lib$$ProjectName

isEmpty(LIB_TYPE) {
    LIB_TYPE = shared
}

contains(LIB_TYPE, static) {
    DEFINES += TARGOMAN_BUILD_STATIC
    CONFIG+=staticlib
} else {
    DEFINES += TARGOMAN_BUILD_SHARED
}

HEADERS += $$DIST_HEADERS \
           $$PRIVATE_HEADERS \
           $$SUBMODULE_HEADERS \

QMAKE_POST_LINK += $$PRJ_BASE_DIR/qmake/linuxPostBuild.sh lib$$ProjectName $$BaseLibraryIncludeFolder $$BaseConfigFolder

include(./install.pri)

message("*******************   $$ProjectName libsrc ************************ ")
message("* Building $$ProjectName Ver. $$VERSION as library")
message("* Base build        : $$BaseBuildFolder")
message("* Target Path       : $$BaseLibraryFolder")
message("* Install Path      : $$PREFIX/")
message("* Library build type: $$LIB_TYPE ")
message("******************************************************************** ")

 
