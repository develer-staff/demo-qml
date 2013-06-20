import QtQuick 2.0

Image {
    id: laser
    property real percentage: .5

    // do not use the percentage property to avoid breaking bindings
    signal percentageChangedByUser(real newPercentage)


    source: "../../resources/icons/verticale.png"

    QtObject {
        id: privateProps

        function recalculateCursorPos(percentage) {
            return laser.percentage * (laser.height - cursor.height)
        }

        function recalculatePercentage(newY) {
            return newY / (laser.height - cursor.height)
        }
    }


    Image {
        id: cursor
        source: mouseArea.pressed ? "../../resources/icons/laser_orizontale_on.png" : "../../resources/icons/laser_orizontale_off.png"
        anchors {
            right: parent.right
            rightMargin: -25 + parent.width / 2 // to align the center of the cursor circle to the center of the laser bar.
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            drag.target: parent
            drag.axis: Drag.YAxis
            drag.minimumY: 0
            drag.maximumY: laser.height - cursor.height

            onPositionChanged: {
                if (drag.active)
                    percentageChangedByUser(privateProps.recalculatePercentage(cursor.y))
            }
        }
    }

    onPercentageChanged: cursor.y = privateProps.recalculateCursorPos(laser.percentage)
    Component.onCompleted: cursor.y = privateProps.recalculateCursorPos(laser.percentage)
}
