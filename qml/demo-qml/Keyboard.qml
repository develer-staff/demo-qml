import QtQuick 2.0
import "Keyboard.js" as KB

Rectangle {
    id: keyboardComponent

    signal keyPressed(string code, int type)
    property variant layout: KB.layout

    color: "lightgray"
    radius: 6
    width: kbd.width + 50
    height: kbd.height + 50

    MouseArea {
        anchors.fill: parent
    }

    Column {
        id: kbd
        spacing: 15
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Repeater {
            id: keyLayout
            model: keyboardComponent.layout.length

            delegate: Row {
                id: keyboardRow
                property variant rowDescription: keyboardComponent.layout[index]

                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: keyboardRow.rowDescription.length

                    delegate:  Rectangle {
                        id: keyDelegate
                        property variant key: keyboardRow.rowDescription[index]

                        border { color: "darkgray"; width: 1 }
                        width: {
                            if (key.type == KB.KeyType.CHARACTER)
                                return 64
                            else if (key.type == KB.KeyType.SPACE)
                                return 500
                            else
                                return 100
                        }
                        height: 64

                        color: keyDelegate.key.type == KB.KeyType.CHARACTER ? "white" : "dimgrey"

                        Text {
                            anchors.centerIn: parent
                            color: keyDelegate.key.type == KB.KeyType.CHARACTER ? "black" : "white"
                            text: keyboardRow.rowDescription[index].label
                        }

                        Image {
                            anchors.centerIn: parent
                            source: keyboardRow.rowDescription[index].icon
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                keyboardComponent.keyPressed(parent.key.code, parent.key.type)
                            }
                        }
                    }
                }
            }
        }
    }
}
