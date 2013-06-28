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
        append({"markerId": 1, "face": CubeView.TOP, "type": type2,
                "x": 150, "y": 100, "index": .35,
               "description": "There are few focal defects identified in the periventricular white matter bilaterally. These are likely due to some superimposed small vessel ischemic change rather than a demyelinating condition. There is no evidence of focal defects identified within the brainstem at any level. The orbits are unremarkable."})
        append({"markerId": 2, "face": CubeView.TOP, "type": type4,
                "x": 330, "y": 300, "index": .5, "description": "The changes in local cerebral activity have two components: a global, region independent change and a local or regional change. As the first step in localizing the regional effects of an activation, global variance must be removed by a normalization procedure."})
        append({"markerId": 3, "face": CubeView.TOP, "type": type8,
                "x": 250, "y": 400, "index": .8, "description": "Early in vivo detection and localization of potentially reversible ischemic cerebral edema may have important research and clinical applications."})
        append({"markerId": 4, "face": CubeView.TOP, "type": type10,
                "x": 150, "y": 300, "index": .1 , "description": "The specific patterns of preserved metabolic activity identified in these patients do not appear to represent random survivals of a few neuronal islands."})

        append({"markerId": 5, "face": CubeView.FRONT, "type": type3,
                "x": 180, "y": 200, "index": .65, "description": "There are areas of new T2 FLAIR hyperintensity in the left insula and bilateral left greater than the right anterior temporal lobes concerning for new foci of metastatic disease."})
        append({"markerId": 6, "face": CubeView.FRONT, "type": type7,
                "x": 280, "y": 260, "index": .25, "description": "The presence of IDH1 mutations was found to carry a very strong prognostic significance for OS but without evidence of a predictive significance for outcome to PCV chemotherapy."})

        append({"markerId": 7, "face": CubeView.SIDE, "type": type1,
                "x": 350, "y": 250, "index": .4 , "description": "The sulci and ventricles are unremarkable. There is no hydrocephalus."})
        append({"markerId": 8, "face": CubeView.SIDE, "type": type3,
                "x": 390, "y": 350, "index": .3 , "description": "These activations correlate with isolated behavioural patterns and metabolic activity."})




    }
}

