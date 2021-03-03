################################################################################
#   QBuildSystem
#
#   Copyright(c) 2021 by Targoman Intelligent Processing <http://tip.co.ir>
#
#   Redistribution and use in source and binary forms are allowed under the
#   terms of BSD License 2.0.
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
include($$QBUILD_PATH/templates/libConfigs.pri)

