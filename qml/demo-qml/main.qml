import QtQuick 2.0
import Qt.labs.folderlistmodel 2.0
import QtGraphicalEffects 1.0
import "CubeView.js" as CubeView
import "Cube.js" as Cube
import "Util.js" as Util

Image {
    id: root

    property real currentIndex: 0.55

    property int globalTopMargin: 128
    source: "../../resources/icons/bg.png"

    Image {
        id: logoDeveler
        source: "../../resources/icons/logo01.png"
        opacity: 1
        anchors {
            top: root.top
            topMargin: 10
            left: root.left
            leftMargin: 10
        }

        Text {
            x: 27
            y: 55
            text: "Software design"
            font.pointSize: 10
            color: "#939393"
        }
        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }

    Image {
        id: logoEngicam
        source: "../../resources/icons/logo02.png"
        opacity: 0
        anchors {
            top: root.top
            topMargin: 10
            left: root.left
            leftMargin: 10
        }

        Text {
            x: 40
            y: 36
            text: "Hardware design"
            font.pointSize: 10
            color: "#939393"
        }

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }

    Timer {
        id: logoAnimationTimer
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            if (logoDeveler.opacity == 1) {
                logoEngicam.opacity = 1
                logoDeveler.opacity = 0
            }
            else {
                logoEngicam.opacity = 0
                logoDeveler.opacity = 1
            }
        }
    }

    Image {
        anchors {
            top: parent.top
            topMargin: 8
            right: parent.right
            rightMargin: 10
        }
        source: "../../resources/icons/s.png"

        Button {
            anchors.centerIn: parent
            icon: "../../resources/icons/search.png"
            onClicked: {
                // ensure keyboard is hidden and reset any states before
                // showing the dialog
                if (!searchDialog.show) {
                    Qt.inputMethod.hide()
                    root.state = ""
                }

                // toggle the dialog
                searchDialog.show = !searchDialog.show
            }
        }
    }


    BorderImage {
        id: patientInfo
        source: "../../resources/icons/s.png"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: root.top
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
            text: Qt.formatDate(new Date(2007, 7, 15), "dddd, MMMM d, yyyy")
            font.pointSize: 16
        }

        TextInput {
            id: text2
            anchors.horizontalCenter: text1.horizontalCenter
            anchors.bottom: patientInfo.bottom
            anchors.bottomMargin: 5
            color: "#0254cd"
            text: "Bruce Dickinson"
            font.pixelSize: 28
            horizontalAlignment: TextInput.AlignHCenter
            width: parent.width - 46
            clip: true
            readOnly: root.state == "editMarker"

            Connections {
                target: Qt.inputMethod
                onVisibleChanged: {
                    // Quick & Dirty solution to hide the cursor when the virtual keyboard disappears.
                    // I don't know if there is a "right" way to do this.
                    text2.cursorVisible = Qt.inputMethod.visible
                }
            }

            onAccepted: {
                if (Qt.inputMethod.visible)
                    Qt.inputMethod.hide()
            }
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
            left: root.left
            leftMargin: 10
            right: view1.left
            rightMargin: 10
            top: root.top
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

    Item {
        id: view1

        anchors {
            top: root.top
            topMargin: globalTopMargin
            left: root.left
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
            currentIndex: 1 - root.currentIndex

            property real strengthFactor: .33
            brightness: brightnessKnob.percentage * strengthFactor
            contrast: contrastKnob.percentage * strengthFactor

            NumberAnimation {
                id: currentIndexAnimation
                target: root
                property: "currentIndex"
            }

            onGotoCurrentIndex: {
                currentIndexAnimation.to = 1 - index
                currentIndexAnimation.duration = Math.abs(index - (1 - root.currentIndex)) * 400
                currentIndexAnimation.start()
            }

            onViewUpdateRequest: {
                var viewports = [view2, view3]
                root.currentIndex = 1 - newIndex

                for (var v = 0; v < 2; v++) {
                    if (viewports[v].currentView === currView) {
                        viewports[v].currentView = prevView
                        viewports[v].image = image
                    }
                }
            }

            onViewResetRequest: {
                root.currentIndex = 1 - index

                view2.currentView = v1
                view2.image = image1

                view3.currentView = v2
                view3.image = image2
            }
        }
    }

    Image {
        source: "../../resources/icons/bigbox_bg.png"
        anchors.centerIn: view1
        z: view1.z - 1
    }

    Column {
        anchors {
            top: root.top
            right: root.right
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
                enabled: root.state == ""
                cursorVisible: {
                    if (cube.currentView === CubeView.TOP ||
                            (verticalLaser.cursorVisible && verticalLaser.cursorOnTop) &&
                            !verticalLaser.doubleCursor)
                        return true
                    else
                        return false
                }

                anchors.verticalCenter: view2.verticalCenter
                percentage: root.currentIndex
                onPercentageChangedByUser: root.currentIndex = newPercentage
            }
        }

        VerticalLaser {
            id: verticalLaser
            z:1
            enabled: root.state == ""
            cursorOnTop: view3.currentView === CubeView.SIDE ? true : false
            cursorVisible: cube.currentView === CubeView.SIDE || cube.currentView === CubeView.FRONT
            doubleCursor: cube.currentView === CubeView.SIDE
            anchors.left: parent.left
            anchors.leftMargin: 14.5
            percentage: root.currentIndex
            onPercentageChangedByUser: root.currentIndex = newPercentage
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
                enabled: root.state == ""
                cursorVisible: {
                    if (cube.currentView === CubeView.TOP ||
                            (verticalLaser.cursorVisible && !verticalLaser.cursorOnTop) &&
                            !verticalLaser.doubleCursor)
                        return true
                    else
                        return false
                }

                anchors.verticalCenter: view3.verticalCenter
                percentage: root.currentIndex
                onPercentageChangedByUser: root.currentIndex = newPercentage
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
                            root.state = "editMarker"
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
                        markerDescription.text = ""
                        root.state = "editMarker"
                    }
                }
            }
        }
    }

    Image {
        source: "../../resources/icons/bg_edit_name.png"
        opacity: keyboardLoader.visible && root.state !== "editMarker" ? 1 : 0
        y: (hasEmbeddedKeyboard ? keyboardLoader.item.keyboardY : 768) - height
        z: 3
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
            color: "#f5f6f8"
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
                visible: root.state == "editMarker"
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
                visible: root.state == "editMarker"
                spacing: 17
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 6
                }

                Button {
                    icon: "../../resources/icons/remove.png"
                    onClicked: {
                        deleteDialog.show(mapToItem(null, width / 2, height / 2))
                        Qt.inputMethod.hide()
                    }

                    Connections {
                        target: deleteDialog
                        onAccepted: {
                            deleteDialog.hide()
                            root.state = ""
                            cube.deleteMarker()
                        }
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
                        root.state = ""
                    }
                }

                Button {
                    icon: "../../resources/icons/conferma.png"
                    onClicked: {
                        cube.markerModel.setMarkerDescription(markerDescription.markerId, markerDescription.text)
                        markerDescription.markerId = -1
                        cube.confirmEditMarker()
                        Qt.inputMethod.hide()
                        root.state = ""
                    }
                }
            }
        }
    }

    Rectangle {
        id: modalBackground
        z: 10
        anchors.centerIn: parent
        width: parent.width - 2
        height: parent.height - 2
        radius: 10
        color: Qt.rgba(1, 1, 1, 0.7)
        visible: opacity > 0
        state: "hidden"

        MouseArea {
            anchors.fill: parent
        }

        states: [
            State {
                name: "hidden"
                PropertyChanges {
                    target: modalBackground
                    opacity: 0
                }
            }
        ]

        transitions: [
            Transition {
                reversible: true
                PropertyAnimation {
                    property: "opacity"
                    duration: 300
                }
            }
        ]
    }

    Item {
        id: floater
        property url image
        property var updateFunc

        z: 20

        BorderImage {
            source: "../../resources/icons/box.png"
            border { top: 8; left: 8; right: 8; bottom: 8 }
            anchors.fill: parent
        }

        Image {
            source: floater.image
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }

        states: [
            State {
                name: ""
                PropertyChanges {
                    target: floater
                    opacity: 1
                    visible: false
                }
            },

            State {
                name: "attached"
                PropertyChanges {
                    target: floater
                    visible: true
                    opacity: 0
                    x: cube.mapToItem(null, cube.width / 2 - floater.width / 2).x
                    y: cube.mapToItem(null, cube.height / 2 - floater.height / 2).y
                    width: 516
                    height: 516
                }
            }
        ]

        transitions: [
            Transition {
                to: "attached"
                SequentialAnimation {
                    PropertyAnimation {
                        properties: "x,y,width,height"
                        duration: 300
                        easing.type: Easing.InExpo
                    }

                    ScriptAction { script: floater.updateFunc() }

                    PropertyAnimation {
                        property: "opacity"
                        duration: 100
                    }
                }
            }
        ]
    }

    SearchDialog {
        id: searchDialog
        property bool show

        /*** private ***/
        property string prevState
        /***************/

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 20
        }

        z: 11
        width: parent.width / 2
        height: parent.height * 0.9
        transformOrigin: Item.TopRight
        visible: opacity > 0
        state: "hidden"

        onSearchInputFocusedChanged: {
            // it doesn't make sense to resize the dialog if there's no
            // keyboard to make room for
            if (!hasEmbeddedKeyboard)
                return

            if (searchInputFocused) {
                prevState = state
                state = "resized"
            }
            else {
                state = prevState
                prevState = ""
            }
        }

        onShowChanged: {
            modalBackground.state = show ? "" : "hidden"
            state = show ? "" : "hidden"
        }

        onCloseRequest: show = false

        onProfileChangeRequest: {
            floater.updateFunc = function() {
                if (view == "top")
                    cube.setConfiguration(CubeView.TOP, imageIndex / topImagesDir.count)
                else if (view == "side")
                    cube.setConfiguration(CubeView.SIDE, imageIndex / sideImagesDir.count)
                else
                    cube.setConfiguration(CubeView.FRONT, imageIndex / frontImagesDir.count)

                text1.text = Qt.formatDate(date, "dddd, MMMM d, yyyy")
                text2.text = name

                show = false
                floater.state = ""
            }

            // resize and position the floater on top of the selected image
            floater.width = geometry.w
            floater.height = geometry.h
            floater.x = geometry.x
            floater.y = geometry.y
            floater.visible = true
            floater.image = image

            // trigger transitions
            state = "fadeOut"
            floater.state = "attached"
            modalBackground.state = "hidden"
        }

        states: [
            State {
                name: "hidden"
                PropertyChanges {
                    target: searchDialog
                    opacity: 0
                    scale: 0
                    anchors.horizontalCenterOffset: root.width / 4
                }
            },

            State {
                name: "fadeOut"
                PropertyChanges { target: searchDialog; opacity: 0 }
            },

            State {
                name: "resized"
                PropertyChanges { target: searchDialog; height: 430 }
            }

        ]

        transitions: [
            Transition {
                reversible: true
                PropertyAnimation {
                    properties: "height,opacity,scale,anchors.horizontalCenterOffset"
                    duration: 300
                }
            }
        ]
    }

    MarkerDeleteDialog {
        id: deleteDialog

        z: 11
        transformOrigin: Item.BottomRight
        width: 400
        height: 200
        opacity: 0
        scale: 0

        function show(origin) {
            x = origin.x
            y = origin.y

            state = "visible"
            modalBackground.state = "show"
        }

        function hide() {
            state = ""
            modalBackground.state = "hidden"
        }

        onRejected: hide()

        states: [
            State {
                name: "visible"
                PropertyChanges {
                    target: deleteDialog
                    opacity: 1
                    scale: 1
                    x: root.width / 2 - deleteDialog.width / 2
                    y: root.height / 2 - deleteDialog.height / 2
                }
            }
        ]

        transitions: Transition {
            reversible: true
            PropertyAnimation {
                duration: 300;
                properties: "opacity,scale,x,y"
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
