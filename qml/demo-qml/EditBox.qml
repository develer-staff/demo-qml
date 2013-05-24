import QtQuick 2.0

Rectangle {
    id: editBox
    property alias text: textLabel.text
    signal editRequest(variant e)

    color: "darkgray"
    border.width: 0

    function setFocus() {
        state = "focused"
    }

    function unsetFocus() {
        state = ""
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
        color: "dimgray"
    }

    states: State {
        name: "focused"
        PropertyChanges { target: editBox; color: "dimgray" }
        PropertyChanges { target: textLabel; color: "white" }
    }

    transitions: Transition {
        to: "focused"
        reversible: true
        PropertyAnimation { property: "color"; duration: 200 }
    }
}
