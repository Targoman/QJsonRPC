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
PRJ_BASE_DIR=$$absolute_path(..)
VersionFile=$$PRJ_BASE_DIR/version.pri
!exists($$VersionFile): error("**** libsrc: Unable to find version info file $$VersionFile ****")
include ($$VersionFile)

!defined(ProjectName, var): error(ProjectName not specified)
!defined(VERSION, var): error(ProjectVERSION not specified)
!defined(PREFIX, var): PREFIX=~/local

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-+-
CONFIG(debug, debug|release): DEFINES += TARGOMAN_SHOW_DEBUG=1
CONFIG(release){
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS_RELEASE += -O3
}

DEFINES += PROJ_VERSION=$$VERSION

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
contains(QT_ARCH, x86_64){
    LibFolderPattern     = $$PREFIX/lib64
} else {
    LibFolderPattern     = $$PREFIX/lib
}
ModulesFolderPattern    = $$PREFIX/modules
LibIncludeFolderPattern = $$PREFIX/include
BinFolderPattern        = bin
BuildFolderPattern      = build
TestBinFolder           = test
UnitTestBinFolder       = unitTest
ConfigFolderPattern     = conf


BaseLibraryFolder        = $$PRJ_BASE_DIR/out/$$LibFolderPattern
BaseModulesFolder        = $$PRJ_BASE_DIR/out/$$ModulesFolderPattern
BaseLibraryIncludeFolder = $$PRJ_BASE_DIR/out/$$LibIncludeFolderPattern
BaseBinFolder            = $$PRJ_BASE_DIR/out/$$BinFolderPattern
BaseTestBinFolder        = $$PRJ_BASE_DIR/out/$$TestBinFolder
BaseUnitTestBinFolder    = $$PRJ_BASE_DIR/out/$$UnitTestBinFolder
BaseBuildFolder          = $$PRJ_BASE_DIR/out/$$BuildFolderPattern/$$ProjectName
BaseConfigFolder         = $$PRJ_BASE_DIR/out/$$ConfigFolderPattern

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
INCLUDEPATH += $$PRJ_BASE_DIR \
               $$PRJ_BASE_DIR/src \
               $$PRJ_BASE_DIR/libsrc \
               $$BaseLibraryIncludeFolder \
               $$PREFIX/include \
               $(HOME)/local/include \
               $$DependencyIncludePaths/

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-
DependencyLibPaths      +=   $$BaseLibraryFolder \
                             $$PRJ_BASE_DIR/out/lib64 \
                             $$PRJ_BASE_DIR/out/lib \
                             $$PREFIX/lib64 \
                             $$PREFIX/lib \
                             $(HOME)/local/lib \
                             $(HOME)/local/lib64 \

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-+-
win32: DEFINES += _WINDOWS
FullDependencySearchPaths = $$DependencyLibPaths
unix:
  FullDependencySearchPaths+=  /usr/lib \
                               /usr/lib64 \
                               /usr/local/lib \
                               /usr/local/lib64 \
                               /lib/x86_64-linux-gnu


QMAKE_LIBDIR += $$FullDependencySearchPaths

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

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-+-
DEPS_BUILT = $$PRJ_BASE_DIR/out/.depsBuilt
Dependencies.target  = $$DEPS_BUILT
Dependencies.depends = FORCE
unix: Dependencies.commands = $$PRJ_BASE_DIR/qmake/buildDeps.sh $$PRJ_BASE_DIR $$DEPS_BUILT $$DONT_BUILD_DEPS;
win32: error(submodule auto-compile has not yet been implemented for windows)

PRE_TARGETDEPS += $$DEPS_BUILT
QMAKE_EXTRA_TARGETS += Dependencies
QMAKE_DISTCLEAN += $$DEPS_BUILT

HEADERS+= $$VERSIONINGHEADER

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-+-
message("*******************   $$ProjectName BASE CONFIG  ************************ ")
message("* Building $$ProjectName Ver. $$VERSION")
message("* Base Project Path :  $$absolute_path(..)")
message("* Base build target : $$PRJ_BASE_DIR/out")
message("* Install Path      : $$PREFIX/")
message("******************************************************************** ")
