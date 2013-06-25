import QtQuick 2.0

Image {
    id: laser
    property real percentage: .2

    property bool cursorOnTop: true
    property bool cursorVisible: true
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

    Image {
        id: cursorImage
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
        visible: laser.cursorVisible && !laser.doubleCursor

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: laser.width - cursorImage.width

            onPositionChanged: {
                if (drag.active)
                    percentageChangedByUser(privateProps.recalculatePercentage(cursorImage.x))
            }
        }
    }

    Image {
        id: doubleCursorImage
        source: mouseAreaDouble.pressed ? "../../resources/icons/laser_verticale_xl_on.png" : "../../resources/icons/laser_verticale_xl_off.png"
        visible: laser.cursorVisible && laser.doubleCursor

        anchors {
            verticalCenter: parent.verticalCenter
        }

        MouseArea {
            id: mouseAreaDouble
            anchors.fill: parent

            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: laser.width - doubleCursorImage.width

            onPositionChanged: {
                if (drag.active)
                    percentageChangedByUser(privateProps.recalculatePercentage(doubleCursorImage.x))
            }
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

