import QtQuick 2.0

Item {
    property string dir
    property string prefix
    property string ext: ".jpg"
    property real   index
    property int    count

    Image {
        id: img
        source: parent.dir + "/" + parent.prefix + Math.round(parent.count * parent.index) + parent.ext
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }
}
