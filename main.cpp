#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#include <QFontDatabase>
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
    viewer.setMainQmlFile(QStringLiteral("qml/demo-qml/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
