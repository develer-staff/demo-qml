import QtQuick 2.0

Image {
    id: laser
    property real percentage: .5
    property bool cursorVisible: true
    property bool enabled: true

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


    BorderImage {
        id: cursor
        border.left: 14
        border.right: 64

        source: mouseArea.pressed ? "../../resources/icons/laser_orizontale_on.png" : "../../resources/icons/laser_orizontale_off.png"
        anchors {
            right: parent.right
            rightMargin: -25 + parent.width / 2 // to align the center of the cursor circle to the center of the laser bar.
        }

        state: laser.cursorVisible ? "" : "hidden"

        states: State {
            name: "hidden"
            PropertyChanges { target: cursor; width: cursor.border.left + cursor.border.right }
            PropertyChanges { target: cursor; opacity: 0 }
        }

        transitions: [
            Transition {
                from: ""
                to: "hidden"
                reversible: true
                SequentialAnimation {
                    NumberAnimation { property: "width"; duration: 200 }
                    NumberAnimation { property: "opacity"; duration: 200 }
                }
            }
        ]

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.margins: -20 // enlarge the mouse area to make it more friendly
            enabled: laser.cursorVisible && laser.enabled

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
