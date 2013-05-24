import QtQuick 2.0
import Qt.labs.folderlistmodel 2.0
import "CubeView.js" as CubeView
import "Cube.js" as Cube

Loader {
    id: loader
    anchors.fill: parent
    sourceComponent: image

    property int currentView
    property real currentIndex

    FolderListModel {
        id: topImagesDir
        folder: "../../resources/top"
        nameFilters: ["*.jpg", "*.png"]
    }
    FolderListModel {
        id: sideImagesDir
        folder: "../../resources/side"
        nameFilters: ["*.jpg", "*.png"]
    }
    FolderListModel {
        id: frontImagesDir
        folder: "../../resources/rear"
        nameFilters: ["*.jpg", "*.png"]
    }

    onCurrentViewChanged: {
        updateView(currentView, currentIndex)
    }

    onCurrentIndexChanged: {
        updateView(currentView, currentIndex)
    }

    property string frontImageSrc
    property string leftImageSrc
    property string rightImageSrc
    property string topImageSrc
    property string bottomImageSrc

    function getImgFile(model) {
        var path = String(model.folder)
        var basename = path.split("/")
        basename = basename[basename.length-1]

        return path + '/' + basename + Math.round(model.count * currentIndex) + ".jpg"
    }

    function updateView(view, index) {
        switch (view) {
        case CubeView.TOP:
            frontImageSrc = getImgFile(topImagesDir)
            leftImageSrc = rightImageSrc = getImgFile(sideImagesDir)
            bottomImageSrc = topImageSrc = getImgFile(frontImagesDir)
            break

        case CubeView.SIDE:
            frontImageSrc = getImgFile(sideImagesDir)
            leftImageSrc = rightImageSrc = getImgFile(frontImagesDir)
            bottomImageSrc = topImageSrc = getImgFile(topImagesDir)
            break

        case CubeView.FRONT:
            frontImageSrc = getImgFile(frontImagesDir)
            leftImageSrc = rightImageSrc = getImgFile(sideImagesDir)
            bottomImageSrc = topImageSrc = getImgFile(topImagesDir)
            break
        }
    }

    Component {
        id: cube
        Cube {
            frontFace: Component {
                Image {
                    fillMode: Image.PreserveAspectFit
                    source: loader.frontImageSrc
                }
            }
            leftFace: Component {
                Image {
                    fillMode: Image.PreserveAspectFit
                    source: loader.leftImageSrc
                }
            }
            rightFace: Component {
                Image {
                    fillMode: Image.PreserveAspectFit
                    source: loader.rightImageSrc
                }
            }
            topFace: Component {
                Image {
                    fillMode: Image.PreserveAspectFit
                    source: loader.topImageSrc
                }
            }
            bottomFace: Component {
                Image {
                    fillMode: Image.PreserveAspectFit
                    source: loader.bottomImageSrc
                }
            }

            onFaceSelected: {
                loader.sourceComponent = image
                switch (face) {
                case Cube.LEFT:
                case Cube.RIGHT:
                    switch (loader.currentView) {
                    case CubeView.FRONT:
                    case CubeView.TOP:
                        loader.currentView = CubeView.SIDE
                        break

                    case CubeView.SIDE:
                        loader.currentView = CubeView.FRONT
                        break
                    }
                    break

                case Cube.TOP:
                case Cube.BOTTOM:
                    switch (loader.currentView) {
                    case CubeView.TOP:
                        loader.currentView = CubeView.FRONT
                        break

                    case CubeView.FRONT:
                    case CubeView.SIDE:
                        loader.currentView = CubeView.TOP
                        break
                    }
                    break
                }
            }
        }
    }

    Component {
        id: image
        Image {
            source: loader.frontImageSrc
            fillMode: Image.PreserveAspectFit
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: {
            loader.sourceComponent = cube
            loader.item.initRotation(mouse)
        }

        onPositionChanged: {
            loader.item.rotate(mouse)
        }

        onReleased: {
            loader.item.finishRotation(mouse)
        }
    }

    Rectangle {
        z: 2
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0)
        border.width: 1
    }
}
