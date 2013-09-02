import QtQuick 2.0

Rectangle {
    id: root
    color: "white"
    border {
        width: 1
        color: "grey"
    }
    clip: true

    ListView {
        id: listView
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        model: ListModel {
            ListElement { name: "Mario Rossi" }
            ListElement { name: "Francesco Bianchi" }
            ListElement { name: "Giuseppe Verdi" }
            ListElement { name: "Pippo Inzaghi" }
            ListElement { name: "Stevan Jovetic" }
        }

        delegate: Item {
            id: element
            property bool expanded
            width: listView.width; height: header.height + content.height
            clip: true
            state: expanded ? "" : "folded"

            Rectangle {
                id: header
                width: parent.width; height: 50
                color: "magenta"

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                    width: parent.width
                    elide: Text.ElideRight
                    color: "black"
                    font.pointSize: 16
                    font.weight: Font.Bold
                    text: name
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: element.expanded = !element.expanded
                }
            }

            Column {
                id: content
                anchors.top: header.bottom
                width: parent.width

                Rectangle {
                    width: parent.width
                    height: Math.max(50, Math.random() * 300)
                    color: "blue"
                }
            }

            states: State {
                name: "folded"
                PropertyChanges { target: element; height: header.height }
                PropertyChanges { target: content; opacity: 0 }
            }

            transitions: Transition {
                reversible: true
                PropertyAnimation { properties: "height,opacity"; duration: 200 }
            }
        }
    }
}
