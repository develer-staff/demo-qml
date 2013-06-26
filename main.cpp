#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#include <QFontDatabase>
#include <QDebug>
#include <QQmlEngine>
#include <QQmlContext>

#if MALIIT
#include <mimpluginmanager.h>
#include <minputcontextconnection.h>
#include <mimserver.h>
#include <connectionfactory.h>
#include <unknownplatform.h>

#include <qpa/qplatforminputcontextfactory_p.h>
#include <qpa/qplatformintegration.h>
#include <qpa/qplatforminputcontext.h>
#include <private/qguiapplication_p.h>
#endif

#include <QDebug>

void loadFonts()
{
    QFontDatabase database;
    bool installed = false;
    foreach (const QString &s, QStringList() << "" << "_Bd")
    {
        QString path = QCoreApplication::applicationDirPath() + "/resources/fonts/VodafoneRg" + s + ".ttf";
        int id = database.addApplicationFont(path);
        if (id == -1) {
            qWarning() << "Error loading the font:" << path;
            continue;
        }

        QStringList families = QFontDatabase::applicationFontFamilies(id);
        if (families.length() > 0 && !installed) {
            qDebug() << "Set default font" << path;
            installed = true;
            QGuiApplication::setFont(QFont(families.at(0)));
        }
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    loadFonts();

    QtQuick2ApplicationViewer viewer;
    viewer.reportContentOrientationChange(Qt::LandscapeOrientation);

#ifdef MALIIT
    MImServer::configureSettings(MImServer::TemporarySettings);
    QSharedPointer<MInputContextConnection> icConnection(Maliit::DBus::createInputContextConnectionWithDynamicAddress());
    QSharedPointer<Maliit::AbstractPlatform> platform(new Maliit::UnknownPlatform);
    MIMPluginManager pm(icConnection, platform);

    QPlatformIntegration *integration = QGuiApplicationPrivate::platformIntegration();

    integration->setInputContext(QPlatformInputContextFactory::create("maliit"));
    qDebug() << "inputContext" << integration->inputContext();

    viewer.engine()->rootContext()->setContextProperty("hasEmbeddedKeyboard", QVariant(true));
#else
    viewer.engine()->rootContext()->setContextProperty("hasEmbeddedKeyboard", QVariant(false));
#endif

    viewer.setMainQmlFile(QStringLiteral("qml/demo-qml/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
