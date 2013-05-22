import QtQuick 2.0

Item {
    property real index

    id: area
    Rectangle {
        id: handle
        width: parent.width
        height: 16
        color: "#434343"

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.YAxis
            drag.minimumY: 0
            drag.maximumY: area.height - parent.height

            onPositionChanged: {
                index = handle.y / (area.height - handle.height)
            }
        }
    }
}
