import QtQuick 2.0

Image {
    id: pad
    property bool enabled: true
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
        readonly property int mouseAreaWidth: 50
        readonly property int mouseAreaHeight: 50

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
        enabled: pad.enabled
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: -10
        }
        onClicked: pad.leftClicked()
        onPressed: privateProps.currentId = privateProps.idLeftButton
        onReleased: if (privateProps.currentId == privateProps.idLeftButton) privateProps.currentId = -1
    }


    MouseArea {
        enabled: pad.enabled
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: -10
        }
        onClicked: pad.topClicked()
        onPressed: privateProps.currentId = privateProps.idTopButton
        onReleased: if (privateProps.currentId == privateProps.idTopButton) privateProps.currentId = -1
    }

    MouseArea {
        enabled: pad.enabled
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: -10
        }
        onClicked: pad.rightClicked()
        onPressed: privateProps.currentId = privateProps.idRightButton
        onReleased: if (privateProps.currentId == privateProps.idRightButton) privateProps.currentId = -1
    }

    MouseArea {
        enabled: pad.enabled
        width: privateProps.mouseAreaWidth
        height: privateProps.mouseAreaHeight
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: -10
        }
        onClicked: pad.bottomClicked()
        onPressed: privateProps.currentId = privateProps.idBottomButton
        onReleased: if (privateProps.currentId == privateProps.idBottomButton) privateProps.currentId = -1
    }

}
