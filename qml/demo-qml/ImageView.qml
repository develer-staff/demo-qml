import QtQuick 2.0

Item {
    property int currentView
    property alias image: img.source

    Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }
}
