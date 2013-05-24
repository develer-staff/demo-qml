import QtQuick 2.0
import "CubeView.js" as CubeView
import "Cube.js" as Cube
import "Util.js" as Util

Loader {
    id: loader
    anchors.fill: parent
    sourceComponent: image

    property int currentView
    property real currentIndex
    signal viewUpdateRequest(int prevView, int currView, string image)

    property variant topImagesDir
    property variant sideImagesDir
    property variant frontImagesDir

    onCurrentIndexChanged: { console.log(currentIndex); updateView() }
    onTopImagesDirChanged: updateView()
    onSideImagesDirChanged: updateView()
    onFrontImagesDirChanged: updateView()

    property string frontImageSrc
    property string leftImageSrc
    property string rightImageSrc
    property string topImageSrc
    property string bottomImageSrc

    onFrontImageSrcChanged: console.log(frontImageSrc)

    function updateView() {
        if (!(loader.topImagesDir && loader.sideImagesDir && loader.frontImagesDir))
            return

        switch (loader.currentView) {
        case CubeView.TOP:
            frontImageSrc = Util.getImgFile(loader.topImagesDir, loader.currentIndex)
            leftImageSrc = rightImageSrc = Util.getImgFile(loader.sideImagesDir, loader.currentIndex)
            bottomImageSrc = topImageSrc = Util.getImgFile(loader.frontImagesDir, loader.currentIndex)
            break

        case CubeView.SIDE:
            frontImageSrc = Util.getImgFile(sideImagesDir, loader.currentIndex)
            leftImageSrc = rightImageSrc = Util.getImgFile(loader.frontImagesDir, loader.currentIndex)
            bottomImageSrc = topImageSrc = Util.getImgFile(loader.topImagesDir, loader.currentIndex)
            break

        case CubeView.FRONT:
            frontImageSrc = Util.getImgFile(frontImagesDir, loader.currentIndex)
            leftImageSrc = rightImageSrc = Util.getImgFile(loader.sideImagesDir, loader.currentIndex)
            bottomImageSrc = topImageSrc = Util.getImgFile(loader.topImagesDir, loader.currentIndex)
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
                var prevView = loader.currentView

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

                loader.viewUpdateRequest(prevView, loader.currentView, loader.frontImageSrc)
                updateView()
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
