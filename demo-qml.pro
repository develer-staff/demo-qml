# Add more folders to ship with the application, here
folder_01.source = qml/demo-qml
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

maliit {
        CONFIG += link_pkgconfig
        PKGCONFIG += maliit-framework maliit-plugins
        QT += dbus gui-private core-private

        # TODO: make the libmaliit-connection a dynamic-link library (to respect the LGPL license)
        # and use the PKG_CONFIG variables to pass the headers path and the linking options to the compiler.
        INCLUDEPATH += $${PWD}/maliit-framework/src $${PWD}/maliit-framework/connection
        LIBS += $${PWD}/maliit-framework/lib/libmaliit-connection.a

        DEFINES += MALIIT
}

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()
