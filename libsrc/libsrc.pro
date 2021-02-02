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
# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
DIST_HEADERS += \
    libQJsonRPC/qjsonrpcmessage.h \
    libQJsonRPC/qjsonrpcservice.h \
    libQJsonRPC/qjsonrpcsocket.h \
    libQJsonRPC/qjsonrpcserviceprovider.h \
    libQJsonRPC/qjsonrpcabstractserver.h \
    libQJsonRPC/qjsonrpclocalserver.h \
    libQJsonRPC/qjsonrpctcpserver.h \
    libQJsonRPC/qjsonrpcglobal.h \
    libQJsonRPC/qjsonrpcservicereply.h \
    libQJsonRPC/qjsonrpchttpclient.h \
    libQJsonRPC/qjsonrpchttpserver.h \
    libQJsonRPC/qjsonrpchttpservermultithreaded.h \

# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
PRIVATE_HEADERS += \
    libQJsonRPC/Private/qjsonrpcservice_p.h \
    libQJsonRPC/Private/qjsonrpcsocket_p.h \
    libQJsonRPC/Private/qjsonrpcabstractserver_p.h \
    libQJsonRPC/Private/qjsonrpcservicereply_p.h \
    libQJsonRPC/Private/qjsonrpchttpserver_p.h \
    libQJsonRPC/Private/http-parser/http_parser.h \
    libQJsonRPC/Private/qjsonrpchttpservermultithreaded_p.h

# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
SOURCES += \
    libQJsonRPC/qjsonrpcmessage.cpp \
    libQJsonRPC/qjsonrpcservice.cpp \
    libQJsonRPC/qjsonrpcsocket.cpp \
    libQJsonRPC/qjsonrpcserviceprovider.cpp \
    libQJsonRPC/qjsonrpcabstractserver.cpp \
    libQJsonRPC/qjsonrpclocalserver.cpp \
    libQJsonRPC/qjsonrpctcpserver.cpp \
    libQJsonRPC/qjsonrpcservicereply.cpp \
    libQJsonRPC/qjsonrpchttpclient.cpp \
    libQJsonRPC/qjsonrpchttpserver.cpp \
    libQJsonRPC/Private/http-parser/http_parser.c \
    libQJsonRPC/qjsonrpchttpservermultithreaded.cpp

# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
OTHER_FILES += \

################################################################################
include(../qmake/libconfigs.pri)

