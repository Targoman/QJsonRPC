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
!contains(CONFIG, no_install) {
    INCLUDE_PREFIX = $$[QT_INSTALL_HEADERS]/
    LIB_PREFIX     = $$[QT_INSTALL_LIBS]
    EXAMPLES_PREFIX= $$[QT_INSTALL_EXAMPLES]

    unix:!isEmpty(PREFIX){
            INCLUDE_PREFIX = $$PREFIX/include/
            contains(QT_ARCH, x86_64){
                LIB_PREFIX     = $$PREFIX/lib64
            } else {
                LIB_PREFIX     = $$PREFIX/lib
            }
    }

    PRJ_BASE_DIR = $${dirname(PWD)}
    for(header, DIST_HEADERS) {
      relPath = $${relative_path($$header, $$PRJ_BASE_DIR)}
      path = $${INCLUDE_PREFIX}/$${dirname(relPath)}
      eval(headers_$${path}.files += $$relPath)
      eval(headers_$${path}.path = $$path)
      eval(INSTALLS *= headers_$${path})
    }

    target = $$TARGET
    target.path = $$LIB_PREFIX

    INSTALLS += target
}





