import QtQuick 2.0
import QtGraphicalEffects 1.0

Image {
    id: bg
    property alias source: image.source
    property int face
    property real brightness: 0
    property real contrast: 0

    source: "../../resources/icons/bigbox.png"
    Image {
        id: image
        width: 500
        height: 500
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
    }

    BrightnessContrast {
        source: image
        anchors.fill: image
        brightness: bg.brightness
        contrast: bg.contrast
    }

    Image {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../../resources/icons/notches_oriz_xl.png"
    }

    Image {
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.verticalCenter: parent.verticalCenter
        source: "../../resources/icons/notches_vert_xl.png"
    }
}
