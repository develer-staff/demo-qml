import QtQuick 2.0
import Qt.labs.folderlistmodel 2.0
import "CubeView.js" as CubeView
import "Util.js" as Util

Rectangle {
    width: 1024
    height: 768

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
        color: '#b6b7bd'
        radius: 10

        anchors {
            left: parent.left
            top: profileBar.bottom
            bottom: tagBar.top
            topMargin: 15
            leftMargin: 30
            rightMargin: 30
            bottomMargin: 15
        }
        height: 653
        width: 653

        CubeView {
            id: cube
            anchors.fill: parent
            topImagesDir: topImagesDir
            sideImagesDir: sideImagesDir
            frontImagesDir: frontImagesDir
            currentView: CubeView.TOP
            currentIndex: 0.5

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

        ImageView {
            id: view2
            width: parent.width
            height: parent.height / 2 - 7
            anchors.top: parent.top
            currentView: CubeView.SIDE
            image: Util.getImgFile(sideImagesDir, cube.currentIndex)

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0)
                border.width: 1
            }
        }

        ImageView {
            id: view3
            width: parent.width
            height: parent.height / 2 - 7
            anchors.bottom: parent.bottom
            currentView: CubeView.FRONT
            image: Util.getImgFile(frontImagesDir, cube.currentIndex)

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0)
                border.width: 1
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
