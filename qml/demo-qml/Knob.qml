import QtQuick 2.0

Item {
    id: knob
    property string label: "color"
    property real percentage: 0

    width: scaleIndicator.width
    height: labelText.y + labelText.height - scaleIndicator.y

    Image {
        id: knobBase
        source: "../../resources/icons/btn.png"
        anchors.centerIn: scaleIndicator
        anchors.verticalCenterOffset: 14
        rotation: knob.percentage * 90

        Image {
            source: "../../resources/icons/incavo.png"
            anchors.top: knobBase.top
            anchors.topMargin: 2
            anchors.horizontalCenter: knobBase.horizontalCenter
            rotation: -knobBase.rotation
        }
    }

    MouseArea {
        anchors.fill: parent
        onPositionChanged: {
            var mouseRelative = mouse.x - knobBase.width / 2
            var percentage = Math.min(Math.max(-1, mouseRelative / (knobBase.width / 2)), 1)
            knob.percentage = percentage
        }
    }

    Image {
        id: scaleIndicator
        source: "../../resources/icons/indicatore.png"
    }

    Text {
        id: labelText

        anchors {
            top: knobBase.bottom
            topMargin: 6
            horizontalCenter: knobBase.horizontalCenter
        }

        text: knob.label
        color: "#939393"
        font.pointSize: 14
    }
}
