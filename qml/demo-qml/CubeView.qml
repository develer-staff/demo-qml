import QtQuick 2.0
import QtGraphicalEffects 1.0
import "CubeView.js" as CubeView
import "Cube.js" as Cube
import "Util.js" as Util

Loader {
    id: loader
    sourceComponent: undefined

    property int currentView
    property real currentIndex
    signal gotoCurrentIndex(real index)
    signal viewUpdateRequest(int prevView, int currView, string image, real newIndex)

    property real brightness: 0
    property real contrast: 0

    property variant topImagesDir
    property variant sideImagesDir
    property variant frontImagesDir

    property url topAnimatedImage
    property url sideAnimatedImage
    property url frontAnimatedImage
    property url animatedImageSrc

    property int rotationPosition: 0
    property int rotationDirection: 0

    onCurrentIndexChanged: {
        CubeView._facesData[loader.currentView] = currentIndex
        changeFrontImage(currentIndex)
    }

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

    property url frontImageSrc
    property url leftImageSrc
    property url rightImageSrc
    property url topImageSrc
    property url bottomImageSrc

    property int frontCubeFace: CubeView.FRONT
    property int leftCubeFace: CubeView.SIDE
    property int rightCubeFace: CubeView.SIDE
    property int topCubeFace: CubeView.TOP
    property int bottomCubeFace: CubeView.TOP

    function selectCubeFace(face) {
        loader.sourceComponent = cubeComponent
        staticFace.visible = false
        loader.item.goToFace(face)
    }

    Component.onCompleted: updateView()

    function updateView() {
        changeFrontImage()
        switch (loader.currentView) {
        case CubeView.TOP:
            leftImageSrc = rightImageSrc = Util.getImgFile(loader.sideImagesDir, CubeView._facesData[CubeView.SIDE])
            bottomImageSrc = topImageSrc = Util.getImgFile(loader.frontImagesDir, CubeView._facesData[CubeView.FRONT])
            frontCubeFace = CubeView.TOP
            leftCubeFace = rightCubeFace = CubeView.SIDE
            bottomCubeFace = topCubeFace = CubeView.FRONT
            break

        case CubeView.SIDE:
            leftImageSrc = rightImageSrc = Util.getImgFile(loader.frontImagesDir, CubeView._facesData[CubeView.FRONT])
            bottomImageSrc = topImageSrc = Util.getImgFile(loader.topImagesDir, CubeView._facesData[CubeView.TOP])
            frontCubeFace = CubeView.SIDE
            leftCubeFace = rightCubeFace = CubeView.FRONT
            bottomCubeFace = topCubeFace = CubeView.TOP
            break

        case CubeView.FRONT:
            leftImageSrc = rightImageSrc = Util.getImgFile(loader.sideImagesDir, CubeView._facesData[CubeView.SIDE])
            bottomImageSrc = topImageSrc = Util.getImgFile(loader.topImagesDir, CubeView._facesData[CubeView.TOP])
            frontCubeFace = CubeView.FRONT
            leftCubeFace = rightCubeFace = CubeView.SIDE
            bottomCubeFace = topCubeFace = CubeView.TOP
            break
        }
    }

    function changeFrontImage(index) {
        var i = index || CubeView._facesData[loader.currentView]
        frontImageSrc = Util.getImgFile(CubeView._imagesData[loader.currentView], i)

        if (loader.currentView == CubeView.TOP)
            staticFace.state = ""
        else if (loader.currentView == CubeView.FRONT)
            staticFace.state = "front"
        else
            staticFace.state = "side"
    }

    property alias markerModel: markerModel

    function addMarker() {
        var existentMarkers = markerModel.markersInFace(currentView)
        var types = [markerModel.type1, markerModel.type2, markerModel.type3, markerModel.type4,
                     markerModel.type5, markerModel.type6, markerModel.type7, markerModel.type8,
                     markerModel.type9, markerModel.type10, markerModel.type11]

        var availableTypes = types.slice()
        for (var i = 0; i < existentMarkers.length; i++) {
            var index = availableTypes.indexOf(existentMarkers[i].type)
            if (index != -1)
                availableTypes.splice(index, 1)
        }

        var type
        if (availableTypes.length > 0)
            type = availableTypes[0]
        else {
            console.warn("No available marker colors")
            return -1
        }

        // 52 is the size of the marker
        var markerId = markerModel.count + 1
        markerModel.append({"markerId": markerId, "face": loader.currentView, "type": type,
                            "description": "", "index": loader.currentIndex,
                            "x": (loader.width - 52) / 2, "y": (loader.height - 52) / 2})
        return markerId
    }

    property Item _editMarker
    property bool _newMarker: false

    function editMarker(markerId, newMarker) {
        _newMarker = (newMarker === true)

        for (var k = 0; k < highResolutionFace.children.length; k++)
            if (highResolutionFace.children[k].__markerComponent) {
                if (highResolutionFace.children[k].markerId != markerId) {
                    if (highResolutionFace.children[k].opacity == 1)
                        highResolutionFace.children[k].opacity = .25
                }
                else {
                    _editMarker = highResolutionFace.children[k]
                    _editMarker.movable = true
                }
            }

        for (var i = 0; i < markerModel.count; i++)
            if (markerModel.get(i).markerId == _editMarker.markerId) {
                loader.gotoCurrentIndex(markerModel.get(i).index)
                break
            }
    }

    function cancelEditMarker() {
        if (_newMarker) { // if the marker is new,  cancel == delete
            deleteMarker()
            return
        }

        // Restore the item position
        for (var i = 0; i < markerModel.count; i++) {
            var model = markerModel.get(i)
            if (model.markerId == _editMarker.markerId) {
                _editMarker.x = model.x
                _editMarker.y = model.y
            }
        }

        _editMarker.movable = false
        _editMarker = null

        for (var k = 0; k < highResolutionFace.children.length; k++)
            if (highResolutionFace.children[k].__markerComponent)
                highResolutionFace.children[k].opacity = (highResolutionFace.children[k].index == loader.currentIndex) ? 1 : 0
    }

    function confirmEditMarker() {
        for (var i = 0; i < markerModel.count; i++)
            if (markerModel.get(i).markerId == _editMarker.markerId) {
                markerModel.setProperty(i, "x", _editMarker.x)
                markerModel.setProperty(i, "y", _editMarker.y)
            }

        _editMarker.movable = false
        _editMarker = null

        for (var k = 0; k < highResolutionFace.children.length; k++)
            if (highResolutionFace.children[k].__markerComponent)
                highResolutionFace.children[k].opacity = markerIsVisible(highResolutionFace.children[k].index) ? 1 : 0
    }

    function deleteMarker() {
        if (!_editMarker)
            return

        for (var i = 0; i < markerModel.count; i++)
            if (markerModel.get(i).markerId == _editMarker.markerId) {
                markerModel.remove(i)
                _editMarker.destroy()
                _editMarker = null
                return
            }
    }

    function markerIsVisible(index) {
        return Math.abs((index - loader.currentIndex)) < 0.05
    }

    Component {
        id: markerComponent
        Image {
            property bool __markerComponent: true
            property int markerId: -1
            property bool movable: false
            property real index

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }

            MouseArea {
                anchors.fill: parent
                visible: parent.movable
                drag.target: parent
                drag.axis: Drag.XAndYAxis
                drag.minimumX: 0
                drag.minimumY: 0
                drag.maximumX: loader.width - parent.width
                drag.maximumY: loader.height - parent.height
            }
        }
    }

    MarkerModel {
        id: markerModel

        function createMarkers(faces) {
            for (var i = 0; i < count; i++) {
                var model = get(i)
                var markerProperties = {"markerId": model.markerId, "source": typeToImage(model.type),
                                        "x": model.x, "y": model.y, "index": model.index, "opacity": markerIsVisible(model.index) ? 1 : 0}

                for (var j = 0; j < faces.length; j++)
                    if (model.face == faces[j].face) {
                        markerComponent.createObject(faces[j], markerProperties)
                    }
            }
        }

        function updateMarkersVisibility(faces) {
            for (var j = 0; j < faces.length; j++)
                for (var k = 0; k < faces[j].children.length; k++)
                    if (faces[j].children[k].__markerComponent)
                        faces[j].children[k].opacity = markerIsVisible(faces[j].children[k].index) ? 1 : 0
        }

        onCountChanged: {
            if (loader.item)
                loader.item.loadMarkers()

            staticFace.loadMarkers()
            highResolutionFace.loadMarkers()
        }
    }

    Component {
        id: cubeComponent

        Cube {
            Component.onCompleted: loadMarkers()

            Connections {
                target: loader
                onCurrentIndexChanged: {
                    var faces = [frontFaceLoader.item, leftFaceLoader.item, rightFaceLoader.item,
                                 topFaceLoader.item, bottomFaceLoader.item]
                    markerModel.updateMarkersVisibility(faces)
                }
            }

            function loadMarkers() {
                var faces = [frontFaceLoader.item, leftFaceLoader.item, rightFaceLoader.item,
                             topFaceLoader.item, bottomFaceLoader.item]

                for (var j = 0; j < faces.length; j++)
                    for (var k = 0; k < faces[j].children.length; k++) {
                        if (faces[j].children[k].__markerComponent) {
                            //console.log("DESTROY ITEM:", faces[j].children[k])
                            faces[j].children[k].destroy()
                        }
                    }

                markerModel.createMarkers(faces)
                markerModel.updateMarkersVisibility(faces)
            }

            frontFaceLoader.sourceComponent: CubeFace {
                source: loader.frontImageSrc
                face: loader.frontCubeFace
                brightness: loader.brightness
                contrast: loader.contrast
            }

            leftFaceLoader.sourceComponent: CubeFace {
                source: loader.leftImageSrc
                face: loader.leftCubeFace
                brightness: loader.brightness
                contrast: loader.contrast
            }

            rightFaceLoader.sourceComponent: CubeFace {
                source: loader.rightImageSrc
                face: loader.rightCubeFace
                brightness: loader.brightness
                contrast: loader.contrast
            }

            topFaceLoader.sourceComponent: CubeFace {
                source: loader.topImageSrc
                face: loader.topCubeFace
                brightness: loader.brightness
                contrast: loader.contrast
            }

            bottomFaceLoader.sourceComponent: CubeFace {
                source: loader.bottomImageSrc
                face: loader.bottomCubeFace
                brightness: loader.brightness
                contrast: loader.contrast
            }

            onFaceSelected: {
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

                // always use the middle image for views on the right of the GUI
                var newImage = Util.getImgFile(CubeView._imagesData[prevView], 0.5)
                var newIndex = CubeView._facesData[loader.currentView]
                updateView()
                loader.viewUpdateRequest(prevView, loader.currentView, newImage, newIndex)
                loader.sourceComponent = undefined
                staticFace.visible = true
            }
            onRotationPositionChanged: loader.rotationPosition = rotationPosition
            onRotationDirectionChanged: loader.rotationDirection = rotationDirection
        }
    }

    Image {
        id: staticFaceBg
        source: "../../resources/icons/bigbox.png"
        visible: staticFace.visible

        anchors.centerIn: parent
    }

    Item {
        id: staticFace
        anchors.fill: staticFaceBg

        function getCurrentItem() {
            if (state == "front")
                return frontAnimatedItem
            else if (state == "side")
                return sideAnimatedItem

            return topAnimatedItem
        }

        function loadMarkers() {
            var item = getCurrentItem()
            for (var k = 0; k < item.children.length; k++)
                if (item.children[k].__markerComponent) {
                    item.children[k].destroy()
                }

            markerModel.createMarkers([item])
            markerModel.updateMarkersVisibility([item])
        }

        function updateCurrentFrame() {
            var item = getCurrentItem()
            item.currentFrame = Math.min(Math.round(loader.currentIndex * item.frameCount), item.frameCount - 1)
        }

        function updateStaticFace() {
            updateCurrentFrame()
            loadMarkers()
        }

        Connections {
            target: loader
            onCurrentIndexChanged: {
                staticFace.updateCurrentFrame()
                markerModel.updateMarkersVisibility([staticFace.getCurrentItem()])
            }
        }

        function preLoadFrames(item) {
            // load all the frames to avoid lag on the first loading
            var oldCurrentFrame = item.currentFrame
            for (var i = 0; i < item.frameCount; i++) {
                if (item.currentFrame < item.frameCount -1)
                    item.currentFrame += 1
                else
                    item.currentFrame = 0
            }
            item.currentFrame = oldCurrentFrame
        }

        Item {
            id: topAnimatedItem
            property int face: CubeView.TOP
            property alias currentFrame: topAnimatedImage.currentFrame
            // for mng animated images frame count is not correct, so we set manually
            property int frameCount: 91
            opacity: 1
            anchors.fill: parent

            AnimatedImage {
                id: topAnimatedImage
                source: loader.topAnimatedImage
                playing: false
                // the sourceSize of the mng animated image is (0,0), so we manual
                // align the image to the parent
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -42
                scale: 2
            }
            Component.onCompleted: parent.preLoadFrames(topAnimatedItem)
        }

        Item {
            id: sideAnimatedItem
            property int face: CubeView.SIDE
            property alias currentFrame: sideAnimatedImage.currentFrame
            property int frameCount: 91
            opacity: 0
            anchors.fill: parent

            AnimatedImage {
                id: sideAnimatedImage
                source: loader.sideAnimatedImage
                playing: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -42
                scale: 2
            }
            Component.onCompleted: parent.preLoadFrames(sideAnimatedItem)
        }

        Item {
            id: frontAnimatedItem
            property int face: CubeView.FRONT
            property alias currentFrame: frontAnimatedImage.currentFrame
            property int frameCount: 91
            opacity: 0
            anchors.fill: parent

            AnimatedImage {
                id: frontAnimatedImage
                source: loader.frontAnimatedImage
                playing: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -42
                scale: 2
            }
            Component.onCompleted: parent.preLoadFrames(frontAnimatedItem)
        }

        states: [
            State {
                name: "front"
                PropertyChanges { target:frontAnimatedItem; opacity: 1 }
                PropertyChanges { target:topAnimatedItem; opacity: 0 }
                PropertyChanges { target:sideAnimatedItem; opacity: 0 }

            },
            State {
                name: "side"
                PropertyChanges { target:sideAnimatedItem; opacity: 1 }
                PropertyChanges { target:topAnimatedItem; opacity: 0 }
                PropertyChanges { target:frontAnimatedItem; opacity: 0 }
            }
        ]

        onStateChanged: updateStaticFace()
        Component.onCompleted: updateStaticFace()
    }

    Image {
        anchors.bottom: staticFaceBg.bottom
        anchors.bottomMargin: 16
        anchors.horizontalCenter: staticFaceBg.horizontalCenter
        source: "../../resources/icons/notches_oriz_xl.png"
        visible: staticFace.visible
    }

    Image {
        anchors.right: staticFaceBg.right
        anchors.rightMargin: 26
        anchors.verticalCenter: staticFaceBg.verticalCenter
        source: "../../resources/icons/notches_vert_xl.png"
        visible: staticFace.visible
    }


    // clipping container to avoid double shadow
    Item {
        anchors.fill: staticFace
        anchors.margins: 3
        z: 1
        clip: true

        CubeFace {
            id: highResolutionFace
            anchors.fill: parent
            anchors.margins: -parent.anchors.margins

            visible: true
            source: visible ? loader.frontImageSrc : ""
            face: loader.frontCubeFace
            onFaceChanged: loadMarkers()
            brightness: loader.brightness
            contrast: loader.contrast

            Connections {
                target: staticFace
                onVisibleChanged: {
                    highResolutionFace.visible = staticFace.visible
                    if (highResolutionFace.visible)
                        markerModel.updateMarkersVisibility([highResolutionFace])
                }
            }

            Connections {
                target: loader
                onCurrentIndexChanged: {
                    if (highResolutionFace.visible)
                        highResolutionFace.visible = false
                    showHighResolutionFaceTimer.restart()
                }
            }

            Timer {
                id: showHighResolutionFaceTimer
                interval: 100
                onTriggered: {
                    highResolutionFace.visible = true
                    markerModel.updateMarkersVisibility([highResolutionFace])
                }
            }

            function loadMarkers() {
                for (var k = 0; k < highResolutionFace.children.length; k++)
                    if (highResolutionFace.children[k].__markerComponent) {
                        highResolutionFace.children[k].destroy()
                    }

                markerModel.createMarkers([highResolutionFace])
                markerModel.updateMarkersVisibility([highResolutionFace])
            }

            Component.onCompleted: loadMarkers()
        }
    }

    BrightnessContrast {
        source: staticFace
        anchors.fill: staticFace
        brightness: loader.brightness
        contrast: loader.contrast
        visible: staticFace.visible
    }

    MouseArea {
        anchors.fill: parent
        visible: !loader._editMarker

        onPressed: {
            loader.sourceComponent = cubeComponent
            staticFace.visible = false
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
