import QtQuick 2.0

BorderImage {
    id: root
    signal closeRequest()
    signal profileChangeRequest(string name, string view, int imageIndex)

    border {
        top: 20
        left: 20
        right: 20
        bottom: 20
    }
    source: "../../resources/icons/dialog_box.png"
    clip: true

    Item {
        id: titleBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            topMargin: 15
        }
        height: 50

        Text {
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
            text: "Patients"
            color: "gray"
            font { pointSize: 14; weight: Font.DemiBold }
        }

        Image {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            source: "../../resources/icons/annulla.png"

            MouseArea {
                anchors.fill: parent
                onClicked: closeRequest()
            }
        }

        Image {
            source: "../../resources/icons/separator.png"
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }

    Item {
        id: searchBar
        anchors {
            top: titleBar.bottom
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
        }

        height: 50

        Image {
            source: "../../resources/icons/search_bar.png"
            anchors.centerIn: parent

            Image {
                id: magIcon
                source: "../../resources/icons/search.png"
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 12 }
            }

            Image {
                id: delIcon
                source: "../../resources/icons/delete.png"
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 13 }
            }

            TextInput {
                id: searchInput
                anchors {
                    left: magIcon.right
                    leftMargin: 5
                    right: delIcon.left
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                }
                clip: true
                font { pointSize: 14; weight: Font.Bold }
                color: "dimgray"
            }
        }

        Image {
            source: "../../resources/icons/separator.png"
            anchors.bottom: parent.bottom
            width: parent.width
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
            top: searchBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 20
        }
        clip: true

        model: ListModel {
            ListElement {
                name: "Mario Rossi"
                text: "Lorem ipsum dolor sit amet, consectetur adipisicing
                    elit, sed do eiusmod tempor incididunt ut labore et dolore
                    magna aliqua."
                view: "rear"
                imageIndex: 20
            }
            ListElement {
                name: "Francesco Bianchi"
                text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem
                    accusantium doloremque laudantium, totam rem aperiam, eaque ipsa
                    quae ab illo inventore veritatis et quasi architecto beatae vitae
                    dicta sunt explicabo."
                view: "top"
                imageIndex: 85
            }
            ListElement {
                name: "Giuseppe Verdi"
                text: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur
                    aut odit aut fugit, sed quia consequuntur magni dolores eos qui
                    ratione voluptatem sequi nesciunt."
                view: "side"
                imageIndex: 30
            }
            ListElement {
                name: "Pippo Inzaghi"
                text: "Neque porro quisquam est, qui dolorem ipsum quia dolor sit
                    amet, consectetur, adipisci velit, sed quia non numquam eius modi
                    tempora incidunt ut labore et dolore magnam aliquam quaerat
                    voluptatem"
                view: "rear"
                imageIndex: 75
            }
            ListElement {
                name: "Stevan Jovetic"
                text: "Ut enim ad minim veniam, quis nostrud exercitation ullamco
                    laboris nisi ut aliquip ex ea commodo consequat."
                view: "top"
                imageIndex: 40
            }
        }

        delegate: Item {
            id: element
            width: listView.width; height: header.height + content.height
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
                    color: "gray"
                    font { pointSize: 16; weight: Font.Bold }
                    textFormat: Text.PlainText
                    text: name
                }

                Image {
                    source: "../../resources/icons/separator.png"
                    anchors.bottom: parent.bottom
                    width: parent.width
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
                    right: parent.right
                }
                spacing: 5

                Rectangle {
                    width: parent.width
                    height: image.height + text.height + sep.height * 2
                    color: "#fdfdfe"

                    Image {
                        id: image
                        anchors {
                            top: parent.top
                            horizontalCenter: parent.horizontalCenter
                        }
                        width: 325; height: 325
                        source: "../../resources/" + view + "/" + view + "0" + imageIndex + ".png"
                    }

                    Image {
                        id: sep
                        source: "../../resources/icons/separator.png"
                        anchors.top: image.bottom
                        width: parent.width
                    }

                    Column {
                        id: text
                        anchors {
                            top: sep.bottom
                            left: parent.left
                            right: parent.right
                            leftMargin: 20
                            rightMargin: 20
                        }
                        spacing: 5

                        Item { width: parent.width; height: 1 }

                        Text {
                            width: parent.width
                            text: String(model.text).replace(/\s+/g, ' ')
                            wrapMode: Text.Wrap
                            font.pointSize: 12
                            textFormat: Text.PlainText
                            color: "dimgray"
                        }

                        Item { width: parent.width; height: 3 }
                    }


                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            profileChangeRequest(name, view, imageIndex);
                            closeRequest()
                        }
                    }

                    Image {
                        source: "../../resources/icons/separator.png"
                        anchors.bottom: parent.bottom
                        width: parent.width
                    }
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
