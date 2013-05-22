import QtQuick 2.0

Rectangle {
    width: 1024
    height: 768

    Cube {
        width: 300
        height: 300
        anchors.centerIn: parent

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
    }
}
