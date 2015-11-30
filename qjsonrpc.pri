QJSONRPC_VERSION = 1.1.0

isEmpty(QJSONRPC_LIBRARY_TYPE) {
    QJSONRPC_LIBRARY_TYPE = shared
}

private-headers {
    DEFINES += USE_QT_PRIVATE_HEADERS
    QT += core-private
}

QT += network
QJSONRPC_INCLUDEPATH = $${PWD}/libsrc/libQJsonRPC
QMAKE_LIBDIR = $${PWD}
QJSONRPC_LIBS = -lqjsonrpc
contains(QJSONRPC_LIBRARY_TYPE, staticlib) {
    DEFINES += QJSONRPC_STATIC
} else {
    DEFINES += QJSONRPC_SHARED
    win32:QJSONRPC_LIBS = -lqjsonrpc1
}

isEmpty(PREFIX) {
    unix {
        PREFIX = /usr
    } else {
        PREFIX = $$[QT_INSTALL_PREFIX]
    }
}
isEmpty(LIBDIR) {
    LIBDIR = lib
}
