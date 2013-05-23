import QtQuick 2.0

Rectangle {
    id: editBox
    property alias text: textLabel.text
    signal editRequest(variant e)

    radius: 10
    color: "darkgray"
    border.width: 0

    function setFocus() {
        textLabel.color = "white"
        editBox.color = "dimgray"
    }

    function unsetFocus() {
        textLabel.color = "dimgray"
        editBox.color = "darkgray"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            editBox.setFocus()
            editBox.editRequest(editBox)
        }
    }

    Text {
        id: textLabel
        anchors { fill: parent; leftMargin: 5; rightMargin: 5 }
        verticalAlignment: Text.AlignVCenter
        clip: true
        color: "gray"
    }
}
