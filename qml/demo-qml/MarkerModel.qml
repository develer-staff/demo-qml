import QtQuick 2.0
import "CubeView.js" as CubeView


ListModel {
    readonly property int type1: 1
    readonly property int type2: 2
    readonly property int type3: 3
    readonly property int type4: 4

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

    function markersInFace(face) {
        var a = []
        for (var i = 0; i < count; i++)
            if (get(i).face == face)
                a.push(get(i))
        return a
    }

    Component.onCompleted: {
        append({"markerId": 1, "face": CubeView.FRONT, "type": type2, "x": 100, "y": 100})
        append({"markerId": 2, "face": CubeView.FRONT, "type": type3, "x": 400, "y": 200})
        append({"markerId": 3, "face": CubeView.SIDE, "type": type1, "x": 250, "y": 200})
        append({"markerId": 4, "face": CubeView.TOP, "type": type4, "x": 400, "y": 300})
        append({"markerId": 5, "face": CubeView.TOP, "type": type2, "x": 250, "y": 400})
    }
}

