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

        anchors {
            top: titleBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 10
        }
        spacing: 5
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        model: ListModel {
            ListElement {
                name: "Mario Rossi"
                text: "Lorem ipsum dolor sit amet, consectetur adipisicing
                    elit, sed do eiusmod tempor incididunt ut labore et dolore
                    magna aliqua."
                image: "rear/rear043.png"
            }
            ListElement {
                name: "Francesco Bianchi"
                text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem
                    accusantium doloremque laudantium, totam rem aperiam, eaque ipsa
                    quae ab illo inventore veritatis et quasi architecto beatae vitae
                    dicta sunt explicabo."
                image: "top/top043.png"
            }
            ListElement {
                name: "Giuseppe Verdi"
                text: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur
                    aut odit aut fugit, sed quia consequuntur magni dolores eos qui
                    ratione voluptatem sequi nesciunt."
                image: "side/side043.png"
            }
            ListElement {
                name: "Pippo Inzaghi"
                text: "Neque porro quisquam est, qui dolorem ipsum quia dolor sit
                    amet, consectetur, adipisci velit, sed quia non numquam eius modi
                    tempora incidunt ut labore et dolore magnam aliquam quaerat
                    voluptatem"
                image: "rear/rear020.png"
            }
            ListElement {
                name: "Stevan Jovetic"
                text: "Ut enim ad minim veniam, quis nostrud exercitation ullamco
                    laboris nisi ut aliquip ex ea commodo consequat."
                image: "top/top060.png"
            }
        }

        delegate: BorderImage {
            id: element
            width: listView.width; height: header.height + content.height
            source: "../../resources/icons/box.png"
            border { top: 8; left: 8; right: 8; bottom: 8 }
            clip: true
            state: listView.opened[index] ? "" : "folded"

            Item {
                id: header
                width: parent.width; height: 50

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
                anchors {
                    top: header.bottom
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
                spacing: 5

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: width
                    color: "white"
                    radius: 8

                    Image {
                        anchors.fill: parent
                        source: "../../resources/" + image
                    }
                }

                Text {
                    width: parent.width
                    text: String(model.text).replace(/\s+/g, ' ')
                    wrapMode: Text.Wrap
                }

                Item { height: 20; width: 20}
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
