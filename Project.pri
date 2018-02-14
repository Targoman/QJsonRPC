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

ProjectDependencies +=

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-+-

CONFIG(debug, debug|release): DEFINES += TARGOMAN_SHOW_DEBUG=1

CONFIG += create_prl
CONFIG += link_prl

CONFIG(release){
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS_RELEASE += -O3
}

DEFINES += TARGOMAN_DEBUG_PROCESS_LINE=1
DEFINES += TARGOMAN_SHOW_WARNING=1
DEFINES += TARGOMAN_SHOW_INFO=1
DEFINES += TARGOMAN_SHOW_HAPPY=1
DEFINES += TARGOMAN_SHOW_NORMAL=1

DEFINES += PROJ_VERSION=$$VERSION

################################################################################
#                     DO NOT CHANGE ANYTHING BELOW
################################################################################

!unix{
  error("********* Compile on OS other than Linux is not ready yet")
}

isEmpty(PREFIX) {
 PREFIX = $$(HOME)/local
}

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
isEmpty(BasePath) {
 BasePath = .
}
BaseOutput=$$BasePath/$$BaseOutput
message("*********************   $$ProjectName CONFIG  ********************** ")
message("* Building $$ProjectName Ver. $$VERSION")
message("* Base Out Path has been set to: $$BaseOutput/")
message("* Install Path has been set to: $$PREFIX/")
message("****************************************************************** ")

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
QT += core
QT -= gui

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
LibFolderPattern        = ./lib
LibIncludeFolderPattern = ./include
BinFolderPattern        = ./bin
BuildFolderPattern      = ./build
TestBinFolder           = ./test
UnitTestBinFolder       = ./unitTest
ConfigFolderPattern     = ./conf

BaseLibraryFolder        = $$BaseOutput/out/$$LibFolderPattern
BaseLibraryIncludeFolder = $$BaseOutput/out/$$LibIncludeFolderPattern
BaseBinFolder            = $$BaseOutput/out/$$BinFolderPattern
BaseTestBinFolder        = $$BaseOutput/out/$$TestBinFolder
BaseUnitTestBinFolder    = $$BaseOutput/out/$$UnitTestBinFolder
BaseBuildFolder          = $$BaseOutput/out/$$BuildFolderPattern/$$ProjectName
BaseConfigFolder         = $$BaseOutput/out/$$ConfigFolderPattern

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
INCLUDEPATH += $$BaseLibraryIncludeFolder \
               $$PREFIX/include \
               $$DependencyIncludePaths/

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
DependencyLibPaths      +=   $$BaseLibraryFolder $$PREFIX/lib
FullDependencySearchPaths=   $$DependencyLibPaths

unix {
  DependencySearchPaths +=

  FullDependencySearchPaths+=  $$DependencySearchPaths \
                               /usr/lib \
                               /usr/lib64 \
                               /usr/local/lib \
                               /usr/local/lib64 \
                               /lib/x86_64-linux-gnu
}

QMAKE_LIBDIR +=  $$DependencyLibPaths

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
unix{
  documentation.path = $$PREFIX/doc
  documentation.files=docs/*
#  documentation.extra=create_docs; mv master.doc toc.doc

  target.files= $$BaseOutput/out/$$BinFolderPattern \
                $$BaseOutput/out/$$LibFolderPattern \
                $$BaseOutput/out/$$LibIncludeFolderPattern \
                $$BaseOutput/out/$$ConfigFolderPattern

  target.path = $$PREFIX/
  target.extra= rm -rvf $$PREFIX/lib/lib/

  INSTALLS += documentation \
              target
}

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
defineTest(addSubdirs) {
    for(subdirs, 1) {
        entries = $$files($$subdirs)
        for(entry, entries) {
            name = $$replace(entry, [/\\\\], _)
            SUBDIRS += $$name
            eval ($${name}.subdir = $$entry)
            for(dep, 2):eval ($${name}.depends += $$replace(dep, [/\\\\], _))
            export ($${name}.subdir)
            export ($${name}.depends)
        }
    }
    export (SUBDIRS)
}

QMAKE_CXXFLAGS += -std=c++11
CONFIGS += c++11

# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
WITH_QJsonRPC{
    !IGNORE_QJsonRPC{
        DEFINES += WITH_QJsonRPC
        ProjectDependencies+= QJsonRPC
    }
}

