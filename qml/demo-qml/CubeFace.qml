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

    // left and right ticks
    Image {
        anchors { left: parent.left; leftMargin: 5; verticalCenter: parent.verticalCenter }
        source: "../../resources/icons/ticks.png"
    }

    Image {
        anchors { right: parent.right; rightMargin: 5; verticalCenter: parent.verticalCenter }
        source: "../../resources/icons/ticks.png"
    }

    // top and bottom ticks
    Image {
        anchors { top: parent.top; topMargin: -6; horizontalCenter: parent.horizontalCenter }
        rotation: 90
        source: "../../resources/icons/ticks.png"
    }

    Image {
        anchors { bottom: parent.bottom; bottomMargin: -4; horizontalCenter: parent.horizontalCenter }
        rotation: 90
        source: "../../resources/icons/ticks.png"
    }
}
