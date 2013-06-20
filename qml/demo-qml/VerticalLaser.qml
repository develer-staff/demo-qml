import QtQuick 2.0

Image {
    id: laser
    property real percentage: .2

    property bool cursorOnTop: true

    // do not use the percentage property to avoid breaking bindings
    signal percentageChangedByUser(real newPercentage)


    source: "../../resources/icons/orizzontale.png"

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
        id: cursor
        source: {
            if (laser.cursorOnTop)
                return mouseArea.pressed ? "../../resources/icons/laser_verticale_d_on.png" : "../../resources/icons/laser_verticale_d_off.png"
            else
                return mouseArea.pressed ? "../../resources/icons/laser_verticale_u_on.png" : "../../resources/icons/laser_verticale_u_off.png"
        }
        anchors {
            top: laser.cursorOnTop ? parent.top : undefined
            bottom: !laser.cursorOnTop ? parent.bottom : undefined
            // to align the center of the cursor circle to the center of the laser bar.
            topMargin: laser.cursorOnTop ? -25 + parent.height/ 2 : undefined
            bottomMargin: !laser.cursorOnTop ? -25 + parent.height/ 2 : undefined
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: laser.width - cursor.width

            onPositionChanged: {
                if (drag.active)
                    percentageChangedByUser(privateProps.recalculatePercentage(cursor.x))
            }
        }
    }

    onPercentageChanged: cursor.x = privateProps.recalculateCursorPos(laser.percentage)
    Component.onCompleted: cursor.x = privateProps.recalculateCursorPos(laser.percentage)
}

