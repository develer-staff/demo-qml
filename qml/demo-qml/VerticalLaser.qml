import QtQuick 2.0

Image {
    id: laser
    property real percentage: .2

    property bool cursorOnTop: true
    property bool cursorVisible: true
    property bool enabled: true
    property bool doubleCursor: false

    property var cursor: doubleCursor ? doubleCursorImage : cursorImage

    // do not use the percentage property to avoid breaking bindings
    signal percentageChangedByUser(real newPercentage)

    source: "../../resources/icons/orizzontale.png"
    state: laser.cursorOnTop ? "" : "cursorOnBottom"

    QtObject {
        id: privateProps

        function recalculateCursorPos(percentage) {
            return laser.percentage * (laser.width - cursor.width)
        }

        function recalculatePercentage(newX) {
            return newX / (laser.width - cursor.width)
        }
    }

    BorderImage {
        id: cursorImage

        border.top: laser.cursorOnTop ? 64 : 14
        border.bottom: laser.cursorOnTop ? 14:  64

        height: sourceSize.height // Why is this required?
        source: {
            if (laser.cursorOnTop)
                return mouseArea.pressed ? "../../resources/icons/laser_verticale_d_on.png" : "../../resources/icons/laser_verticale_d_off.png"
            else
                return mouseArea.pressed ? "../../resources/icons/laser_verticale_u_on.png" : "../../resources/icons/laser_verticale_u_off.png"
        }

        anchors {
            top: parent.top
            // to align the center of the cursor circle to the center of the laser bar.
            topMargin: -25 + parent.height/ 2
        }

        state: laser.cursorVisible && !laser.doubleCursor ? "" : "hidden"
        states: State {
            name: "hidden"
            PropertyChanges { target: cursorImage; height: cursorImage.border.top + cursorImage.border.bottom }
            PropertyChanges { target: cursorImage; opacity: 0 }
        }

        transitions: [
            Transition {
                from: ""
                to: "hidden"
                reversible: true
                SequentialAnimation {
                    NumberAnimation { property: "height"; duration: 200 }
                    NumberAnimation { property: "opacity"; duration: 200 }
                }
            }
        ]
    }

    MouseArea {
        id: mouseArea
        anchors.fill: cursorImage
        anchors.margins: -20 // enlarge the mouse area to make it more friendly
        enabled: laser.cursorVisible && !laser.doubleCursor && laser.enabled

        drag.target: cursorImage
        drag.axis: Drag.XAxis
        drag.minimumX: 0
        drag.maximumX: laser.width - cursorImage.width

        onPositionChanged: {
            if (drag.active)
                percentageChangedByUser(privateProps.recalculatePercentage(cursorImage.x))
        }
    }

    Column {
        id: doubleCursorImage
        anchors.verticalCenter: parent.verticalCenter
        x: privateProps.recalculateCursorPos(percentage)

        BorderImage {
            id: topImage
            border.top: 14
            border.bottom: 38
            source: mouseAreaDouble.pressed ? "../../resources/icons/laser_verticale_xl_top_on.png" : "../../resources/icons/laser_verticale_xl_top_off.png"
        }

        BorderImage {
            id: bottomImage
            border.top: 36
            border.bottom: 14
            source: mouseAreaDouble.pressed ? "../../resources/icons/laser_verticale_xl_bottom_on.png" : "../../resources/icons/laser_verticale_xl_bottom_off.png"
        }

        state: laser.cursorVisible && laser.doubleCursor ? "" : "hidden"
        states: State {
            name: "hidden"
            PropertyChanges { target: topImage; height: topImage.border.top + topImage.border.bottom }
            PropertyChanges { target: topImage; opacity: 0 }
            PropertyChanges { target: bottomImage; height: bottomImage.border.top + bottomImage.border.bottom }
            PropertyChanges { target: bottomImage; opacity: 0 }
        }

        transitions: [
            Transition {
                from: ""
                to: "hidden"
                reversible: true
                SequentialAnimation {
                    NumberAnimation { property: "height"; duration: 200 }
                    NumberAnimation { property: "opacity"; duration: 200 }
                }
            }
        ]
    }

    MouseArea {
        id: mouseAreaDouble
        anchors.fill: doubleCursorImage
        anchors.margins: -20 // enlarge the mouse area to make it more friendly
        enabled: laser.cursorVisible && laser.doubleCursor && laser.enabled

        drag.target: doubleCursorImage
        drag.axis: Drag.XAxis
        drag.minimumX: 0
        drag.maximumX: laser.width - doubleCursorImage.width

        onPositionChanged: {
            if (drag.active)
                percentageChangedByUser(privateProps.recalculatePercentage(doubleCursorImage.x))
        }
    }

    states: [
        State {
            name: "cursorOnBottom"
            AnchorChanges {
                target: cursorImage
                anchors.top: undefined
                anchors.bottom: laser.bottom
            }
            PropertyChanges {
                target: cursorImage
                anchors.topMargin: 0
                anchors.bottomMargin: -25 + laser.height / 2
            }
        }
    ]

    onPercentageChanged: cursor.x = privateProps.recalculateCursorPos(laser.percentage)
    Component.onCompleted: cursor.x = privateProps.recalculateCursorPos(laser.percentage)
}

