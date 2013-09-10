import QtQuick 2.0

BorderImage {
    id: root
    signal accepted()
    signal rejected()

    border {
        top: 20
        left: 20
        right: 20
        bottom: 20
    }
    source: "../../resources/icons/dialog_box.png"
    clip: true

    Column {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        spacing: 20

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.8
            wrapMode: Text.Wrap
            text: "The marker is going to be deleted. Are you sure?"
            color: "darkslategray"
            font.pointSize: 15
            textFormat: Text.PlainText
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Button {
                icon: "../../resources/icons/conferma.png"
                onClicked: accepted()
            }

            Button {
                icon: "../../resources/icons/annulla.png"
                onClicked: rejected()
            }
        }
    }
}
