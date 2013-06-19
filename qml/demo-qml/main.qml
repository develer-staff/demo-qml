import QtQuick 2.0
import Qt.labs.folderlistmodel 2.0
import "CubeView.js" as CubeView
import "Util.js" as Util

Image {
    id: background
    source: "../../resources/icons/bg.png"

    Image {
        id: logo
        source: "../../resources/icons/logo01.png"
        anchors {
            top: background.top
            topMargin: 20
            left: background.left
            leftMargin: 10
        }
    }

    BorderImage {
        id: patientInfo
        source: "../../resources/icons/s.png"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: logo.verticalCenter
        }

        width: 360; height: 78
        border.left: 38; border.top: 39
        border.right: 38; border.bottom: 39

        Text {
            id: text1
            anchors.horizontalCenter: patientInfo.horizontalCenter
            anchors.top: patientInfo.top
            anchors.topMargin: 5
            color: "#939393"
            text: Qt.formatDate(new Date(), "dddd, MMMM d, yyyy")
            font.pointSize: 16
        }

        Text {
            id: text2
            x: 27
            y: 36
            color: "#0254cd"
            text: "Mario Rossi"
            font.pixelSize: 28
        }

        Text {
            id: text3
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: text2.verticalCenter
            text: qsTr("Male, 35 yo")
            font.pixelSize: 16
        }
    }

    FolderListModel {
        id: topImagesDir
        folder: "../../resources/top"
        nameFilters: ["*.png"]
    }
    FolderListModel {
        id: sideImagesDir
        folder: "../../resources/side"
        nameFilters: ["*.png"]
    }
    FolderListModel {
        id: frontImagesDir
        folder: "../../resources/rear"
        nameFilters: ["*.png"]
    }

    Column {
        id: imageControls
        anchors {
            left: background.left
            leftMargin: 10
            right: view1.left
            rightMargin: 10
            top: background.top
            topMargin: 100
        }
        spacing: 20
        Knob {
            id: brightnessKnob
            label: "Brigthness"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Knob {
            id: contrastKnob
            label: "Contrast"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Column {
        anchors {
            bottom: view1.bottom
            left: background.left
            leftMargin: 10
            right: view1.left
            rightMargin: 10
        }

        Pad {
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Rotation")
            font.pixelSize: 16
            color: "#939393"
        }
    }

    Image {
        id: view1

        source: "../../resources/icons/bigbox.png"
        anchors {
            top: background.top
            topMargin: 100
            left: background.left
            leftMargin: 150
        }
        clip: true

        CubeView {
            id: cube
            anchors.fill: parent
            topImagesDir: topImagesDir
            sideImagesDir: sideImagesDir
            frontImagesDir: frontImagesDir
            currentView: CubeView.TOP
            currentIndex: 0.5

            brightness: brightnessKnob.percentage
            contrast: contrastKnob.percentage

            onViewUpdateRequest: {
                var viewports = [view2, view3]

                for (var v = 0; v < 2; v++) {
                    if (viewports[v].currentView === currView) {
                        viewports[v].currentView = prevView
                        viewports[v].image = image
                    }
                }
            }
        }
    }

    Image {
        source: "../../resources/icons/bigbox_bg.png"
        anchors.centerIn: view1
        anchors.verticalCenterOffset: 2
        z: view1.z - 1
    }

    Column {
        anchors {
            top: background.top
            right: background.right
            topMargin: 100
            rightMargin: 50
        }
        spacing: 18

        Row {
            spacing: 20
            ImageView {
                id: view2
                currentView: CubeView.SIDE
                image: Util.getImgFile(sideImagesDir, cube.currentIndex)
            }

            VerticalLaser {
                anchors.verticalCenter: view2.verticalCenter
                percentage: .3
                //onPercentageChangedByUser: console.log("percentage changed: " + newPercentage)
            }
        }

        Image {
            source: "../../resources/icons/orizzontale.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 20
            ImageView {
                id: view3
                currentView: CubeView.FRONT
                image: Util.getImgFile(frontImagesDir, cube.currentIndex)
            }

            VerticalLaser {
                anchors.verticalCenter: view3.verticalCenter
                percentage: .5
            }
        }
    }

    BorderImage {
        id: markersInfo
        source: "../../resources/icons/s.png"
        anchors {
            bottom: parent.bottom
            bottomMargin: 6
            left: parent.left
            leftMargin: 10
        }

        width: 910; height: 78
        border.left: 38; border.top: 39
        border.right: 38; border.bottom: 39
    }

    Image {
        source: "../../resources/icons/s.png"
        anchors {
            verticalCenter: markersInfo.verticalCenter
            right: parent.right
            rightMargin: 10
        }

        Button {
            icon: "../../resources/icons/add.png"
            anchors.centerIn: parent
            onClicked: console.log("Add marker!")
        }
    }

    KeyboardLauncher {
        id: kbdLauncher
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        width: parent.width
        height: parent.height / 2
    }
}
