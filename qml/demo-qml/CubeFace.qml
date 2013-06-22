import QtQuick 2.0


Rectangle {
    property alias source: image.source
    property int face

    color: '#f4f4f4'
    border.color: '#fefefe'
    border.width: 3
    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }
}
