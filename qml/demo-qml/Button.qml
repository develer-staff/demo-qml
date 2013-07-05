import QtQuick 2.0

Item {
    id: button

    property url image: "../../resources/icons/btn.png"
    property url pressedImage: "../../resources/icons/btn_highlighted.png"
    property url icon
    property real iconScale: 1

    signal clicked

    width: bg.width
    height: bg.height

    Image {
        id: bg
        source: mouseArea.pressed ? button.pressedImage : button.image
    }

    Image {
        anchors.centerIn: bg
        source: button.icon
        scale: button.iconScale
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -10
        onClicked: button.clicked()
    }
}
