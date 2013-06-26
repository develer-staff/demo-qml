import QtQuick 2.0
import Qt.labs.folderlistmodel 2.0
import QtGraphicalEffects 1.0
import "CubeView.js" as CubeView
import "Cube.js" as Cube
import "Util.js" as Util

Image {
    id: background

    property real currentIndex: 0.5
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
            text: Qt.formatDate(new Date(2013, 7, 8), "dddd, MMMM d, yyyy")
            font.pointSize: 16
        }

        Text {
            id: text2
            anchors.horizontalCenter: text1.horizontalCenter
            anchors.bottom: patientInfo.bottom
            anchors.bottomMargin: 5
            color: "#0254cd"
            text: "John Smith"
            font.pixelSize: 28
        }
    }

    FolderListModel {
        id: topImagesDir
        folder: "../../resources/top"
        nameFilters: ["*.jpg"]
    }
    FolderListModel {
        id: sideImagesDir
        folder: "../../resources/side"
        nameFilters: ["*.jpg"]
    }
    FolderListModel {
        id: frontImagesDir
        folder: "../../resources/rear"
        nameFilters: ["*.jpg"]
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
            onTopClicked: cube.selectCubeFace(Cube.TOP)
            onLeftClicked: cube.selectCubeFace(Cube.LEFT)
            onBottomClicked: cube.selectCubeFace(Cube.BOTTOM)
            onRightClicked: cube.selectCubeFace(Cube.RIGHT)
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

        CubeView {
            id: cube
            anchors.centerIn: parent
            width: 500
            height: 500
            clip: true
            topImagesDir: topImagesDir
            sideImagesDir: sideImagesDir
            frontImagesDir: frontImagesDir

            topAnimatedImage: "../../resources/top.gif"
            sideAnimatedImage: "../../resources/side.gif"
            frontAnimatedImage: "../../resources/rear.gif"

            currentView: CubeView.TOP
            currentIndex: 1 - background.currentIndex

            brightness: brightnessKnob.percentage
            contrast: contrastKnob.percentage

            NumberAnimation {
                id: currentIndexAnimation
                target: background
                property: "currentIndex"
            }

            onGotoCurrentIndex: {
                currentIndexAnimation.to = 1 - index
                currentIndexAnimation.duration = Math.abs(index - (1 - background.currentIndex)) * 400
                currentIndexAnimation.start()
            }

            onViewUpdateRequest: {
                var viewports = [view2, view3]
                background.currentIndex = 1 - newIndex

                for (var v = 0; v < 2; v++) {
                    if (viewports[v].currentView === currView) {
                        viewports[v].currentView = prevView
                        viewports[v].image = image
                    }
                }

                end_gradient.visible = false
                start_gradient.visible = false
            }

            onRotationPositionChanged: {
                // Adjust the amount if negative (movement bottom -> top or right -> left)
                if (rotationPosition < 0) {
                    rotationPosition = view1.width + rotationPosition;
                }
                else if (rotationPosition == 0) {
                    rotationPosition = view1.width;
                }

                // clamp 0 <= value <= 650
                rotationPosition = rotationPosition > view1.width ? view1.width : rotationPosition;
                rotationPosition = rotationPosition < 0 ? 0 : rotationPosition;

                var alpha_end = rotationPosition / view1.width;
                var alpha_start = 1.0 - alpha_end;

                if (rotationDirection === Cube.DIRECTION_X) {
                    start_gradient.visible = true;
                    start_gradient.start = Qt.point(0, 0);
                    start_gradient.end = Qt.point(rotationPosition, 0);
                    start_gradient.gradient.stops[0].color.a = alpha_start;

                    end_gradient.visible = true;
                    end_gradient.start = Qt.point(rotationPosition, 0);
                    end_gradient.end = Qt.point(view1.width, 0);
                    end_gradient.gradient.stops[1].color.a = alpha_end;
                }
                else if (rotationDirection === Cube.DIRECTION_Y) {
                    start_gradient.visible = true;
                    start_gradient.start = Qt.point(0, 0);
                    start_gradient.end = Qt.point(0, rotationPosition);
                    start_gradient.gradient.stops[0].color.a = alpha_start;

                    end_gradient.visible = true;
                    end_gradient.start = Qt.point(0, rotationPosition);
                    end_gradient.end = Qt.point(0, view1.width);
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
        anchors.fill: view1
        gradient: Gradient {
            GradientStop { position: 0.50; color: "#b6b7bd" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    LinearGradient {
        id: end_gradient
        z: 100
        visible: false
        anchors.fill: view1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.50; color: "#dee0e5" }
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

        // Visibility conditions for lasers
        // - When TOP is in big box => 2 horizontal lasers
        // - when SIDE in big box => double vertical laser
        // - when FRONT in big box => horizontal cursor points to SIDE view
        Row {
            spacing: 20
            ImageView {
                id: view2
                currentView: CubeView.SIDE
                image: Util.getImgFile(sideImagesDir, 0.5)
            }

            HorizontalLaser {
                id: topLaser
                cursorVisible: {
                    if (cube.currentView === CubeView.TOP ||
                            (verticalLaser.cursorVisible && verticalLaser.cursorOnTop) &&
                            !verticalLaser.doubleCursor)
                        return true
                    else
                        return false
                }

                anchors.verticalCenter: view2.verticalCenter
                percentage: background.currentIndex
                onPercentageChangedByUser: background.currentIndex = newPercentage
            }
        }

        VerticalLaser {
            id: verticalLaser
            z:1
            cursorOnTop: view3.currentView === CubeView.SIDE ? true : false
            cursorVisible: cube.currentView === CubeView.SIDE || cube.currentView === CubeView.FRONT
            doubleCursor: cube.currentView === CubeView.SIDE
            anchors.left: parent.left
            anchors.leftMargin: 14.5
            percentage: background.currentIndex
            onPercentageChangedByUser: background.currentIndex = newPercentage
        }

        Row {
            spacing: 20
            ImageView {
                id: view3
                currentView: CubeView.FRONT
                image: Util.getImgFile(frontImagesDir, 0.5)
            }

            HorizontalLaser {
                id: bottomLaser
                cursorVisible: {
                    if (cube.currentView === CubeView.TOP ||
                            (verticalLaser.cursorVisible && !verticalLaser.cursorOnTop) &&
                            !verticalLaser.doubleCursor)
                        return true
                    else
                        return false
                }

                anchors.verticalCenter: view3.verticalCenter
                percentage: background.currentIndex
                onPercentageChangedByUser: background.currentIndex = newPercentage
            }
        }
    }

    Item {
        id: markersArea
        anchors {
            bottom: parent.bottom
            bottomMargin: 6
            left: parent.left
            leftMargin: 10
            right: parent.right
        }
        height: 78

        BorderImage {
            id: markersInfo
            source: "../../resources/icons/s.png"

            width: 910;
            border.left: 38; border.top: 39
            border.right: 38; border.bottom: 39
            opacity: 1

            Row {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                spacing: 15

                Repeater {
                    model: cube.markerModel.markersInFace(cube.currentView)
                    delegate: Button {
                        icon: cube.markerModel.typeToImage(modelData.type)
                        iconScale: .7
                        onClicked: {
                            cube.editMarker(modelData.markerId)
                            markerDescription.markerId = modelData.markerId
                            markerDescription.text = cube.markerModel.getMarkerDescription(modelData.markerId)
                            markersArea.state = "editMarker"
                        }
                    }
                }

                add: Transition {
                    id: addTransition
                    property int duration: 180

                    SequentialAnimation {
                        PropertyAction { property: "scale"; value: addTransition.ViewTransition.index > 0 ? .7 : 1 }
                        PropertyAction { property: "z"; value: 100 - addTransition.ViewTransition.index }
                        PauseAnimation { duration: (addTransition.duration + 20)* addTransition.ViewTransition.index }
                        ParallelAnimation {
                            NumberAnimation {
                                property: "x"
                                from: (Math.max(0, addTransition.ViewTransition.index -1) * 88)
                                duration: addTransition.duration
                            }
                            NumberAnimation { property: "scale"; to: 1; duration: addTransition.duration }
                        }
                    }
                }
            }
        }

        Image {
            opacity: markersInfo.opacity
            source: "../../resources/icons/s.png"
            anchors {
                verticalCenter: markersInfo.verticalCenter
                right: parent.right
                rightMargin: 10
            }

            Button {
                icon: "../../resources/icons/add.png"
                anchors.centerIn: parent
                onClicked: {
                    var markerId = cube.addMarker()
                    cube.editMarker(markerId, true)
                    markerDescription.markerId = markerId
                    markerDescription.text = cube.markerModel.getMarkerDescription(markerId)
                    markersArea.state = "editMarker"
                }
            }
        }

        Image {
            id: markerDescription
            property alias text: textInput.text
            property int markerId: -1

            source: "../../resources/icons/descrizione_bg.png"
            opacity: 0
            clip: true

            TextEdit {
                id: textInput
                visible: markersArea.state == "editMarker"
                anchors.fill: parent
                anchors.margins: 8
                font.pixelSize: 16
                wrapMode: TextInput.WordWrap
                color: "#939393"
            }
        }

        BorderImage {
            source: "../../resources/icons/s.png"

            anchors {
                left: markerDescription.right
                leftMargin: 10
                right: parent.right
                rightMargin: 10
            }

            border.left: 38; border.top: 39
            border.right: 38; border.bottom: 39
            opacity: markerDescription.opacity

            Row {
                visible: markersArea.state == "editMarker"
                spacing: 15
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }

                Button {
                    icon: "../../resources/icons/003.png"
                    onClicked: {
                        cube.deleteMarker()
                        markersArea.state = ""
                    }
                }


                Item {
                    height: 64
                    width: 64
                }

                Button {
                    icon: "../../resources/icons/002.png"
                    onClicked: {
                        markerDescription.markerId = -1
                        cube.cancelEditMarker()
                        markersArea.state = ""
                    }
                }

                Button {
                    icon: "../../resources/icons/004.png"
                    onClicked: {
                        cube.markerModel.setMarkerDescription(markerDescription.markerId, markerDescription.text)
                        markerDescription.markerId = -1
                        cube.confirmEditMarker()
                        markersArea.state = ""
                    }
                }
            }
        }

        states: State {
            name: "editMarker"
            PropertyChanges { target: markersInfo; opacity: 0 }
            PropertyChanges { target: markerDescription; opacity: 1 }
        }

        transitions: Transition {
            SequentialAnimation {
                NumberAnimation { target: markersInfo; property: "opacity"; duration: 200 }
                NumberAnimation { target: markerDescription; property: "opacity"; duration: 200 }
            }
        }
    }



    KeyboardLauncher {
        id: kbdLauncher
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        width: parent.width
        height: parent.height / 2
    }
}
