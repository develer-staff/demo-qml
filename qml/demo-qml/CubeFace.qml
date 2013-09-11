import QtQuick 2.0
import QtGraphicalEffects 1.0

Image {
    id: bg
    property alias source: image.source
    property int face
    property real brightness: 0
    property real contrast: 0
    property bool active: true

    state: active ? "active" : ""

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
        id: ticksLeft
        opacity: 0.3
        anchors { left: parent.left; leftMargin: 5; verticalCenter: parent.verticalCenter }
        source: "../../resources/icons/ticks.png"
    }

    Image {
        id: ticksRight
        opacity: 0.3
        anchors { right: parent.right; rightMargin: 5; verticalCenter: parent.verticalCenter }
        source: "../../resources/icons/ticks.png"
    }

    // top and bottom ticks
    Image {
        id: ticksTop
        opacity: 0.3
        anchors { top: parent.top; topMargin: -6; horizontalCenter: parent.horizontalCenter }
        rotation: 90
        source: "../../resources/icons/ticks.png"
    }

    Image {
        id: ticksBottom
        opacity: 0.3
        anchors { bottom: parent.bottom; bottomMargin: -4; horizontalCenter: parent.horizontalCenter }
        rotation: 90
        source: "../../resources/icons/ticks.png"
    }

    states: State {
        name: "active"
        PropertyChanges { target: ticksLeft; opacity: 0.8 }
        PropertyChanges { target: ticksRight; opacity: 0.8 }
        PropertyChanges { target: ticksTop; opacity: 0.8 }
        PropertyChanges { target: ticksBottom; opacity: 0.8 }
    }

    transitions: Transition {
        reversible: true
        PropertyAnimation { property: "opacity"; duration: 200 }
    }
}
