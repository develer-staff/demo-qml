import QtQuick 2.0

Image {
    property int currentView
    property alias image: img.source

    source: "../../resources/icons/box.png"

    Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: "../../resources/icons/box_bg.png"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 2
        z: parent.z - 1
    }
}
