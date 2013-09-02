import QtQuick 2.0

BorderImage {
    id: root
    signal closeRequest()
    border {
        top: 8
        left: 8
        right: 8
        bottom: 8
    }
    source: "../../resources/icons/bigbox.png"

    clip: true

    Item {
        id: titleBar
        width: parent.width; height: 50

        Text {
            anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
            text: "Patients"
        }

        Image {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            source: "../../resources/icons/s.png"
            scale: 0.5

            Button {
                anchors.centerIn: parent
                icon: "../../resources/icons/annulla.png"
                onClicked: closeRequest()
            }
        }

    }

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

        anchors { top: titleBar.bottom; bottom: parent.bottom }
        width: parent.width

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
