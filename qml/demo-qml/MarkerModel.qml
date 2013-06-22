import QtQuick 2.0
import "CubeView.js" as CubeView


ListModel {
    readonly property int type1: 1
    readonly property int type2: 2
    readonly property int type3: 3
    readonly property int type4: 4

    property Component markerComponent: Component {
        Image {
            property bool __markerComponent: true
        }
    }

    function typeToImage(t) {
        switch (t) {
        case type1:
            return "../../resources/icons/001.png"
        case type2:
            return "../../resources/icons/002.png"
        case type3:
            return "../../resources/icons/003.png"
        case type4:
        default:
            return "../../resources/icons/004.png"
        }
    }

    Component.onCompleted: {
        append({"face": CubeView.FRONT, "type": type2, "x": 100, "y": 100})
        append({"face": CubeView.FRONT, "type": type3, "x": 400, "y": 200})
        append({"face": CubeView.SIDE, "type": type1, "x": 250, "y": 200})
        append({"face": CubeView.TOP, "type": type4, "x": 400, "y": 300})
        append({"face": CubeView.TOP, "type": type2, "x": 250, "y": 400})
    }
}

