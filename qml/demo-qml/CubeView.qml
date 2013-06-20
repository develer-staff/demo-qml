import QtQuick 2.0
import QtGraphicalEffects 1.0
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

    property real brightness: 0
    property real contrast: 0

    property variant topImagesDir
    property variant sideImagesDir
    property variant frontImagesDir

    onCurrentIndexChanged: updateView()

    Connections {
        target: topImagesDir
        onCountChanged: updateView();
    }
    Connections {
        target: sideImagesDir
        onCountChanged: updateView();
    }
    Connections {
        target: frontImagesDir
        onCountChanged: updateView();
    }

    property string frontImageSrc
    property string leftImageSrc
    property string rightImageSrc
    property string topImageSrc
    property string bottomImageSrc

    Component.onCompleted: updateView()

    function updateView() {
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
            frontFace: Rectangle {
                color: '#f4f4f4'
                border.color: '#fefefe'
                border.width: 3
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: loader.frontImageSrc
                }
            }
            leftFace: Rectangle {
                color: '#f4f4f4'
                border.color: '#fefefe'
                border.width: 3
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: loader.leftImageSrc
                }
            }
            rightFace: Rectangle {
                color: '#f4f4f4'
                border.color: '#fefefe'
                border.width: 3
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: loader.rightImageSrc
                }
            }
            topFace: Rectangle {
                color: '#f4f4f4'
                border.color: '#fefefe'
                border.width: 3
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: loader.topImageSrc
                }
            }
            bottomFace: Rectangle {
                color: '#f4f4f4'
                border.color: '#fefefe'
                border.width: 3
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: loader.bottomImageSrc
                }
            }

            onFaceSelected: {
                start_gradient.visible = false;
                end_gradient.visible = false;

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
            onRotated: {
                // params: direction, amount

                // Adjust the amount if negative (movement bottom -> top or right -> left)
                if (amount < 0) {
                    amount = loader.width + amount;
                }
                else if (amount == 0) {
                    amount = loader.width;
                }

                // clamp 0 <= value <= 650
                amount = amount > loader.width ? loader.width : amount;
                amount = amount < 0 ? 0 : amount;

                var alpha_end = amount / loader.width;
                var alpha_start = 1.0 - alpha_end;

                if (direction === Cube.DIRECTION_X) {
                    start_gradient.visible = true;
                    start_gradient.start = Qt.point(0, 0);
                    start_gradient.end = Qt.point(amount, 0);
                    start_gradient.gradient.stops[0].color.a = alpha_start;

                    end_gradient.visible = true;
                    end_gradient.start = Qt.point(amount, 0);
                    end_gradient.end = Qt.point(loader.width, 0);
                    end_gradient.gradient.stops[1].color.a = alpha_end;
                }
                else if (direction === Cube.DIRECTION_Y) {
                    start_gradient.visible = true;
                    start_gradient.start = Qt.point(0, 0);
                    start_gradient.end = Qt.point(0, amount);
                    start_gradient.gradient.stops[0].color.a = alpha_start;

                    end_gradient.visible = true;
                    end_gradient.start = Qt.point(0, amount);
                    end_gradient.end = Qt.point(0, loader.width);
                    end_gradient.gradient.stops[1].color.a = alpha_end;
                }
                else {
                    start_gradient.visible = false;
                    end_gradient.visible = false;
                }
            }
        }
    }

    LinearGradient {
        id: start_gradient
        z: 100
        visible: false
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.50; color: "#b6b7bd" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    LinearGradient {
        id: end_gradient
        z: 100
        visible: false
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.50; color: "#dee0e5" }
        }
    }

    Component {
        id: image

        Image {
            anchors.fill: parent
            source: loader.frontImageSrc
            fillMode: Image.PreserveAspectFit

            BrightnessContrast {
                anchors.fill: parent
                source: parent
                brightness: loader.brightness
                contrast: loader.contrast
            }
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
}
