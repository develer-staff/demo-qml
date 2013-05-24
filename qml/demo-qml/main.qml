import QtQuick 2.0

Rectangle {
    width: 1024
    height: 768

    EditBox {
        id: profileBar
        height: 32
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 15
            leftMargin: 30
            rightMargin: 30
        }
        onEditRequest: kbdLauncher.processEditRequest(e)
    }

    Rectangle {
        id: view1
        anchors {
            left: parent.left
            top: profileBar.bottom
            bottom: tagBar.top
            topMargin: 15
            leftMargin: 30
            rightMargin: 30
            bottomMargin: 15
        }
        width: 650
        border.width: 1
        Cube {
            width: parent.width * 0.8
            height: parent.height * 0.8
            anchors.centerIn: parent

            onFaceSelected: {
                console.log("Selected face:", face)
            }

            frontFace: Component {
                Rectangle {
                    color: "red"
                }
            }

            leftFace: Component {
                Rectangle {
                    color: "green"
                }
            }

            rightFace: Component {
                Rectangle {
                    color: "blue"
                }
            }

            topFace: Component {
                Rectangle {
                    color: "magenta"
                }
            }

            bottomFace: Component {
                Rectangle {
                    color: "purple"
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.initRotation(mouse)
                }

                onPositionChanged: {
                    parent.rotate(mouse)
                }

                onReleased: {
                    parent.finishRotation()
                }
            }
        }
    }

    Item {
        anchors {
            top: profileBar.bottom
            bottom: tagBar.top
            left: view1.right
            right: parent.right
            topMargin: 15
            bottomMargin: 15
            leftMargin: 15
            rightMargin: 30
        }

        Rectangle {
            id: view2
            width: parent.width
            height: parent.height / 2 - 7
            anchors.top: parent.top
            border.width: 1
        }

        Rectangle {
            id: view3
            width: parent.width
            height: parent.height / 2 - 7
            anchors.bottom: parent.bottom
            border.width: 1

            EditBox {
                width: parent.width
                anchors.top: parent.top
                height: 32
                onEditRequest: kbdLauncher.processEditRequest(e)
            }
        }
    }

    Rectangle {
        id: tagBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin:30
            rightMargin: 30
            bottomMargin: 15
        }
        height: 64
        border.width: 1
    }

    KeyboardLauncher {
        id: kbdLauncher
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        width: parent.width
        height: parent.height / 2
    }
}
