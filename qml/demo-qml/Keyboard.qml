import QtQuick 2.0
import "Keyboard.js" as KB

Rectangle {
    id: keyboardComponent

    property variant layout: KB.layout
    signal keyPressed(string code, int type)
    signal closed

    color: "lightgray"
    radius: 6
    width: kbd.width + 50
    height: kbd.height + 50

    // just to stop propagation of any mouse events at lower elements
    MouseArea { anchors.fill: parent }

    Image {
        anchors { top: parent.top; right: parent.right; margins: 15 }
        source: "../../resources/icons/shared/close.png"

        MouseArea {
            anchors.fill: parent
            onClicked: keyboardComponent.closed()
        }
    }

    Column {
        id: kbd
        spacing: 15
        anchors.centerIn: keyboardComponent

        Repeater {
            id: keyLayout
            model: keyboardComponent.layout.length

            delegate: Row {
                id: keyRow
                property variant keys: keyboardComponent.layout[index]

                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: keyRow.keys.length
                    delegate: Rectangle {
                        id: keyRect
                        property variant key: keyRow.keys[index]

                        border { color: "darkgray"; width: 1 }
                        height: 64
                        width: {
                            if (key.type === KB.KeyType.CHARACTER)
                                return 64
                            else if (key.type === KB.KeyType.SPACE)
                                return 500
                            else
                                return 100
                        }

                        color: key.type === KB.KeyType.CHARACTER ? "white" : "dimgrey"

                        Text {
                            id: keyLabel
                            anchors.centerIn: parent
                            color: parent.key.type === KB.KeyType.CHARACTER ? "black" : "white"
                            text: parent.key.label
                        }

                        Image {
                            anchors.centerIn: parent
                            source: parent.key.icon
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                if (parent.key.type === KB.KeyType.CHARACTER)
                                    parent.state = "charKeyPressed"
                                else
                                    parent.state = "ctrlKeyPressed"
                                keyboardComponent.keyPressed(parent.key.code, parent.key.type)
                            }

                            onReleased: {
                                parent.state = ""
                            }
                        }

                        states: [
                            State {
                                name: "charKeyPressed"
                                PropertyChanges { target: keyRect; color: "gray" }
                                PropertyChanges { target: keyLabel; color: "white" }
                            },
                            State {
                                name: "ctrlKeyPressed"
                                PropertyChanges { target: keyRect; color: "gainsboro" }
                                PropertyChanges { target: keyLabel; color: "black" }
                            }
                        ]

                        transitions: [
                            Transition {
                                to: "charKeyPressed,ctrlKeyPressed"
                                reversible: true
                                PropertyAnimation { property: "color"; duration: 50 }
                            }
                        ]
                    }
                }
            }
        }
    }
}
