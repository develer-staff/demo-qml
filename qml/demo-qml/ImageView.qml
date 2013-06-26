import QtQuick 2.0

Image {
    property int currentView
    property alias image: img.source

    source: "../../resources/icons/box.png"

    Image {
        id: img
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        width: 200
        height: 200
    }

    Image {
        source: "../../resources/icons/box_bg.png"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 2
        z: parent.z - 1
    }
}
