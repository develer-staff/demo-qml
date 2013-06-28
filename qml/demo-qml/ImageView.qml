import QtQuick 2.0

Image {
    property int currentView
    property alias image: img.source
    property bool verticalLaser: false

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
        z: parent.z - 1
    }

    BorderImage {
        border.left: 6
        border.right: 6
        border.bottom: 6
        border.top: 6
        width: 208
        height: 208
        anchors.centerIn: parent
        source: verticalLaser ? "../../resources/icons/notches_vert.png" : "../../resources/icons/notches_oriz.png"
    }
}
