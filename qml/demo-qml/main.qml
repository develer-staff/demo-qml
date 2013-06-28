import QtQuick 2.0
import Qt.labs.folderlistmodel 2.0
import QtGraphicalEffects 1.0
import "CubeView.js" as CubeView
import "Cube.js" as Cube
import "Util.js" as Util

Image {
    id: background

    property real currentIndex: 0.5

    property int globalTopMargin: 128
    source: "../../resources/icons/bg.png"

    Image {
        id: logoDeveler
        source: "../../resources/icons/logo01.png"
        anchors {
            top: background.top
            topMargin: 25
            left: background.left
            leftMargin: 10
        }

        Text {
            x: 13
            y: -18
            text: "Software design"
            font.pointSize: 10
            color: "#babbc0"
        }
    }

    Image {
        id: logoEngicam
        source: "../../resources/icons/logo02.png"
        anchors {
            top: background.top
            topMargin: 25
            right: background.right
            rightMargin: 20
        }

        Text {
            x: 71
            y: -14
            text: "Hardware design"
            font.pointSize: 10
            color: "#babbc0"
        }
    }

    BorderImage {
        id: patientInfo
        source: "../../resources/icons/s.png"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: background.top
            topMargin: 6
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
            text: Qt.formatDate(new Date(2013, 6, 8), "dddd, MMMM d, yyyy")
            font.pointSize: 16
        }

        TextInput {
            id: text2
            anchors.horizontalCenter: text1.horizontalCenter
            anchors.bottom: patientInfo.bottom
            anchors.bottomMargin: 5
            color: "#0254cd"
            text: "John Smith"
            font.pixelSize: 28
            horizontalAlignment: TextInput.AlignHCenter
            width: parent.width - 46
            clip: true
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
            topMargin: globalTopMargin
        }
        spacing: 40
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
            enabled: background.state == ""
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

    Item {
        id: view1

        anchors {
            top: background.top
            topMargin: globalTopMargin
            left: background.left
            leftMargin: 150
        }
        width: 516
        height: 516
        z: 1
        clip: true

        CubeView {
            id: cube
            anchors.fill: parent
            topImagesDir: topImagesDir
            sideImagesDir: sideImagesDir
            frontImagesDir: frontImagesDir

            topAnimatedImage: "../../resources/top/top.mng"
            sideAnimatedImage: "../../resources/side/side.mng"
            frontAnimatedImage: "../../resources/rear/rear.mng"

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
                    start_gradient.end = Qt.point(rotationPosition * 0.66, 0);
                    start_gradient.gradient.stops[0].color.a = alpha_start;

                    end_gradient.visible = true;
                    end_gradient.start = Qt.point(rotationPosition + (view1.width - rotationPosition) * 0.66, 0);
                    end_gradient.end = Qt.point(view1.width, 0);
                    end_gradient.gradient.stops[1].color.a = alpha_end;
                }
                else if (rotationDirection === Cube.DIRECTION_Y) {
                    start_gradient.visible = true;
                    start_gradient.start = Qt.point(0, 0);
                    start_gradient.end = Qt.point(0, rotationPosition * 0.66);
                    start_gradient.gradient.stops[0].color.a = alpha_start;

                    end_gradient.visible = true;
                    end_gradient.start = Qt.point(0, rotationPosition + (view1.width - rotationPosition) * 0.66);
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
        z: 10
        visible: false
        anchors.fill: view1
        gradient: Gradient {
            GradientStop { position: 0.50; color: "#e2e4e8" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    LinearGradient {
        id: end_gradient
        z: 10
        visible: false
        anchors.fill: view1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.50; color: "#e2e4e8" }
        }
    }

    Image {
        source: "../../resources/icons/bigbox_bg.png"
        anchors.centerIn: view1
        z: view1.z - 1
    }

    Column {
        anchors {
            top: background.top
            right: background.right
            topMargin: globalTopMargin
            rightMargin: 50
        }
        spacing: 21

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
                verticalLaser: verticalLaser.cursorVisible && (verticalLaser.doubleCursor || !verticalLaser.cursorOnTop)
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
                verticalLaser: verticalLaser.cursorVisible && (verticalLaser.doubleCursor || verticalLaser.cursorOnTop)
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

            width: 874
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
                        icon: cube.markerModel.typeToSmallImage(modelData.type)
                        onClicked: {
                            cube.editMarker(modelData.markerId)
                            markerDescription.markerId = modelData.markerId
                            markerDescription.text = cube.markerModel.getMarkerDescription(modelData.markerId)
                            background.state = "editMarker"
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
                    if (markerId > 0) {
                        cube.editMarker(markerId, true)
                        markerDescription.markerId = markerId
                        markerDescription.text = cube.markerModel.getMarkerDescription(markerId)
                        background.state = "editMarker"
                    }
                }
            }
        }
    }

    Image {
        id: markerBackground
        source: "../../resources/icons/bg_edit_marker.png"
        opacity: 0
        y: (hasEmbeddedKeyboard ? keyboardLoader.item.keyboardY : 768) - height
        z: 3

        Rectangle {
            anchors.bottom: parent.bottom
            height: 10
            width: parent.width
            visible: keyboardLoader.visible
        }

        Image {
            id: markerDescription
            property alias text: textInput.text
            property int markerId: -1

            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 10

            source: "../../resources/icons/descrizione_bg.png"
            opacity: markerBackground.opacity
            clip: true

            TextEdit {
                id: textInput
                visible: background.state == "editMarker"
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
                verticalCenter: markerDescription.verticalCenter
            }

            border.left: 38; border.top: 39
            border.right: 38; border.bottom: 39
            opacity: markerDescription.opacity

            Row {
                visible: background.state == "editMarker"
                spacing: 17
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 6
                }

                Button {
                    icon: "../../resources/icons/remove.png"
                    onClicked: {
                        cube.deleteMarker()
                        Qt.inputMethod.hide()
                        background.state = ""
                    }
                }


                Item {
                    height: 64
                    width: 64
                }

                Button {
                    icon: "../../resources/icons/annulla.png"
                    onClicked: {
                        markerDescription.markerId = -1
                        cube.cancelEditMarker()
                        Qt.inputMethod.hide()
                        background.state = ""
                    }
                }

                Button {
                    icon: "../../resources/icons/conferma.png"
                    onClicked: {
                        cube.markerModel.setMarkerDescription(markerDescription.markerId, markerDescription.text)
                        markerDescription.markerId = -1
                        cube.confirmEditMarker()
                        Qt.inputMethod.hide()
                        background.state = ""
                    }
                }
            }
        }
    }

    states: State {
        name: "editMarker"
        PropertyChanges { target: markersInfo; opacity: 0 }
        PropertyChanges { target: markerBackground; opacity: 1 }
    }

    transitions: [
        Transition {
            from: ""
            to: "editMarker"
            SequentialAnimation {
                NumberAnimation { target: markersInfo; property: "opacity"; duration: 200 }
                NumberAnimation { target: markerBackground; property: "opacity"; duration: 200 }
            }
        },
        Transition {
            from: "editMarker"
            to: ""
            SequentialAnimation {
                NumberAnimation { target: markerBackground; property: "opacity"; duration: 200 }
                NumberAnimation { target: markersInfo; property: "opacity"; duration: 200 }
            }
        }
    ]

    KeyboardLauncher {
        id: kbdLauncher
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        width: parent.width
        height: parent.height / 2
    }

    Loader {
        id: keyboardLoader
        visible: false
        anchors.fill: parent
        z: 101
        source: hasEmbeddedKeyboard ? MInputMethodQuick.qmlFileName : ""

        Connections {
            id: kbdConn
            target: hasEmbeddedKeyboard ? MInputMethodQuick : null

            onActiveChanged: {
                if (MInputMethodQuick.active) {
                    keyboardLoader.visible = true
                }
                else
                    hideKeyboardTimer.start()
            }
        }

        Timer {
            id: hideKeyboardTimer
            interval: 500 // the time needed by the keyboard to perform the hide animation
            onTriggered: keyboardLoader.visible = false
        }
    }
}
