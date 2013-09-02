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

        /* This array contains booleans which indicate the state
        (opened/closed) of delegates. Modifying this array (by calling
        setOpened()) will fold or expand the delegate at given position. The
        setOpened() function also guarantees that there's only one opened
        delegate at the moment. */
        property var opened: {
            var arr = []
            for (var i = 0; i < count; i++)
                arr.push(false)

            return arr
        }

        function setOpened(index, state) {
            if (opened[index] !== state) {
                // close any currently opened element
                var idx = opened.indexOf(true)
                if (idx !== -1)
                    opened[idx] = false

                // update
                opened[index] = state
                openedChanged()
            }
        }

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
            width: listView.width; height: header.height + content.height
            clip: true
            state: listView.opened[index] ? "" : "folded"

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
                    onClicked: listView.setOpened(index, !listView.opened[index])
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
