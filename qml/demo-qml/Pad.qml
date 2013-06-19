import QtQuick 2.0

Image {
    id: pad
    signal topClicked()
    signal bottomClicked()
    signal leftClicked()
    signal rightClicked()

    source: {
        switch (privateProps.currentId) {

        case privateProps.idLeftButton:
            return "../../resources/icons/buttons_l.png"
        case privateProps.idTopButton:
            return "../../resources/icons/buttons_u.png"
        case privateProps.idRightButton:
            return "../../resources/icons/buttons_r.png"
        case privateProps.idBottomButton:
            return "../../resources/icons/buttons_d.png"
        default:
            return "../../resources/icons/buttons_0.png"
        }
    }

    QtObject {
        id: privateProps
        readonly property int mouseAreaWidth: 40
        readonly property int mouseAreaHeight: 40

        readonly property int idLeftButton: 1
        readonly property int idTopButton: 2
        readonly property int idRightButton: 3
        readonly property int idBottomButton: 4
        property int currentId: -1
    }

    Image {
        source: "../../resources/icons/glifo_rotazione.png"
        anchors.centerIn: parent
    }

    MouseArea {
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors.verticalCenter: parent.verticalCenter
        onClicked: pad.leftClicked()
        onPressed: privateProps.currentId = privateProps.idLeftButton
        onReleased: if (privateProps.currentId == privateProps.idLeftButton) privateProps.currentId = -1
    }

    MouseArea {
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: pad.topClicked()
        onPressed: privateProps.currentId = privateProps.idTopButton
        onReleased: if (privateProps.currentId == privateProps.idTopButton) privateProps.currentId = -1
    }

    MouseArea {
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        onClicked: pad.rightClicked()
        onPressed: privateProps.currentId = privateProps.idRightButton
        onReleased: if (privateProps.currentId == privateProps.idRightButton) privateProps.currentId = -1
    }

    MouseArea {
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        onClicked: pad.bottomClicked()
        onPressed: privateProps.currentId = privateProps.idBottomButton
        onReleased: if (privateProps.currentId == privateProps.idBottomButton) privateProps.currentId = -1
    }

}
