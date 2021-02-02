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

!defined(TEST_NAME, var): TEST_NAME=tst_$$ProjectName

TEMPLATE = app
TARGET=$$TEST_NAME
QT+=testlib

DESTDIR      = $$BaseTestBinFolder
MOC_DIR      = $$BaseBuildFolder/$$TARGET/moc
OBJECTS_DIR  = $$BaseBuildFolder/$$TARGET/obj
RCC_DIR      = $$BaseBuildFolder/$$TARGET/rcc
UI_DIR       = $$BaseBuildFolder/$$TARGET/ui

INCLUDEPATH += $$PRJ_BASE_DIR/libsrc
INCLUDEPATH+=$$PRJ_BASE_DIR/libsrc/lib$$ProjectName/Private/
INCLUDEPATH+=$$PRJ_BASE_DIR/libsrc/lib$$ProjectName/
QMAKE_LIBDIR += $$BaseLibraryFolder
LIBS += -l$$ProjectName

message("*******************   $$ProjectName  TEST ************************ ")
message("* Building $$ProjectName Ver. $$VERSION test $$TEST_NAME")
message("* Base build        : $$BaseBuildFolder/$$TARGET")
message("* Target Path       : $$BaseTestBinFolder")
message("******************************************************************** ")
