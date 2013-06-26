import QtQuick 2.0
import "CubeView.js" as CubeView


ListModel {
    readonly property int type1: 1
    readonly property int type2: 2
    readonly property int type3: 3
    readonly property int type4: 4
    readonly property int type5: 5
    readonly property int type6: 6
    readonly property int type7: 7
    readonly property int type8: 8
    readonly property int type9: 9
    readonly property int type10: 10
    readonly property int type11: 11

    function typeToImage(t) {
        return "../../resources/icons/0" + (t > 9 ? "" : "0") + t  + ".png"
    }

    function typeToSmallImage(t) {
        return "../../resources/icons/0" + (t > 9 ? "" : "0") + t  + "s.png"
    }

    function markersInFace(face) {
        var a = []
        for (var i = 0; i < count; i++)
            if (get(i).face == face)
                a.push(get(i))
        return a
    }

    function getMarkerDescription(markerId) {
        for (var i = 0; i < count; i++)
            if (get(i).markerId == markerId)
                return get(i).description

        console.warn("Cannot find a marker with id:", markerId)
        return ""
    }

    function setMarkerDescription(markerId, description) {
        for (var i = 0; i < count; i++)
            if (get(i).markerId == markerId) {
                setProperty(i, "description", description)
                return
            }

        console.warn("Cannot find a marker with id:", markerId)
    }

    Component.onCompleted: {
        append({"markerId": 1, "face": CubeView.FRONT, "type": type2,
                "x": 100, "y": 100, "description": "Marker 1 description", "index": .1})
        append({"markerId": 2, "face": CubeView.FRONT, "type": type3,
                "x": 400, "y": 200, "description": "Marker 2 description", "index": .65})
        append({"markerId": 3, "face": CubeView.SIDE, "type": type1,
                "x": 250, "y": 200, "description": "Marker 3 description", "index": .4})
        append({"markerId": 4, "face": CubeView.TOP, "type": type4,
                "x": 400, "y": 300, "description": "Marker 4 description", "index": .5})
        append({"markerId": 5, "face": CubeView.TOP, "type": type8,
                "x": 250, "y": 400, "description": "Marker 5 description", "index": .8})
    }
}

