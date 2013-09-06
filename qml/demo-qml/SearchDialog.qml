import QtQuick 2.0

BorderImage {
    id: root
    signal closeRequest()
    signal profileChangeRequest(string name, var date, string view, int imageIndex, url image, var geometry)

    property alias searchInputFocused: searchInput.focus

    border {
        top: 20
        left: 20
        right: 20
        bottom: 20
    }
    source: "../../resources/icons/dialog_box.png"
    clip: true

    readonly property var staticDataModel: [
        {
            name: "Brian Johnson",
            text: "Ophthalmoplegic migraine. Unenhanced images reveal smooth
            enlargement and homogeneous enhancement of cisternal segment of
            left oculomotor.",
            view: "rear",
            imageIndex: 20,
            date: "2013-04-25"
        },
        {
            name: "Jim Morrison",
            text: "Metastatic melanoma and meningeal carcinomatosis.
            Contrast-enhanced axial and coronal T1-weighted images show
            enhancement and involvement of multiple cranial nerves: oculomotor
            nerves, trigeminal nerves, complex of seventh and eighth cranial
            nerves, complex of ninth, tenth, and eleventh cranial nerves,
            hypoglossal nerves.",
            view: "top",
            imageIndex: 85,
            date: "2009-11-10"
        },
        {
            name: "Eric Adams",
            text: "Patient after resection of adenoid cystic carcinoma of right
            hard palate. Axial bone image shows widening of right
            pterygopalatine fossa.",
            view: "side",
            imageIndex: 30,
            date: "2012-02-22"
        },
        {
            name: "James Hetfield",
            text: "Acute lymphoblastic leukemia. Axial image reveals leukemic
            infiltrate of left pons and brachium pontis. Contrast-enhanced
            axial images show antegrade perineural extension along course of
            left spinal trigeminal tract and nuclei into preganglionic segment
            of left trigeminal nerve.",
            view: "rear",
            imageIndex: 75,
            date: "2013-09-03"
        },
        {
            name: "Bruce Dickinson",
            text: "Tuberculous meningitis. Contrast-enhanced axial and coronal
            images show abnormal peripheral enhancement of oculomotor nerves.
            In addition, there is leptomeningeal enhancement of anterior
            surface of brainstem.",
            view: "top",
            imageIndex: 40,
            date: "2007-08-15"
        },
        {
            name: "Howard Wolowitz",
            text: "Patient with perineural spread of rhinocerebral mucormycosis who
            presented for follow-up after right orbital exenteration. Axial images
            show recurrence of infection with invasion of right cavernous sinus and
            retrograde involvement of trigeminal nerve along cavernous, ganglionic,
            and cisternal segments. Abnormal signal within right pons indicates
            edema.",
            view: "side",
            imageIndex: 80,
            date: "2005-04-03"
        }
    ]

    function hideKeyboard() {
        root.forceActiveFocus()

        if (hasEmbeddedKeyboard)
            MInputMethodQuick.userHide()
    }

    function updateDataModel(pattern) {
        var result = []
        pattern = pattern.toLowerCase()

        for (var i = 0; i < staticDataModel.length; i++) {
            var itemName = staticDataModel[i].name.toLowerCase()

            if (itemName.search(pattern) !== -1)
                result.push(staticDataModel[i])
        }

        listView.model = result
    }

    Item {
        id: titleBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            topMargin: 15
        }
        height: 50

        Text {
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
            text: "Patients"
            color: "darkslategray"
            font.pointSize: 15
        }

        Image {
            anchors { right: parent.right; rightMargin: -6; verticalCenter: parent.verticalCenter }
            source: "../../resources/icons/annulla.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    hideKeyboard()
                    closeRequest()
                }
            }
        }

        Image {
            source: "../../resources/icons/separator.png"
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }

    Item {
        id: searchBar
        anchors {
            top: titleBar.bottom
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
        }

        height: 50

        Image {
            source: "../../resources/icons/search_bar.png"
            anchors.centerIn: parent

            Image {
                id: magIcon
                source: "../../resources/icons/search.png"
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 10 }
            }

            Image {
                id: delIcon
                source: "../../resources/icons/delete.png"
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 7 }
                opacity: searchInput.text.length ? 1 : 0.5

                MouseArea {
                    enabled: searchInput.text.length
                    anchors.fill: parent
                    onClicked: searchInput.text = ""
                }
            }

            TextInput {
                id: searchInput
                anchors {
                    left: magIcon.right
                    leftMargin: 5
                    right: delIcon.left
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                }
                clip: true
                font { pointSize: 14; weight: Font.Bold }
                color: "dimgray"

                onTextChanged: updateTimer.restart()

                // when the input box gains focus, close currently opened element (if any)
                onFocusChanged: if (focus) listView.setOpened(listView.opened.indexOf(true), false)

                Timer {
                    id: updateTimer
                    interval: 100
                    onTriggered: updateDataModel(searchInput.text)
                }
            }
        }

        Image {
            source: "../../resources/icons/separator.png"
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }

    ListView {
        id: listView

        /* This array contains booleans which indicate the state
        (opened/closed) of delegates. Modifying this array (by calling
        setOpened()) will fold or expand the delegate at given position. The
        setOpened() function also guarantees that there's only one opened
        delegate at the moment. */
        property var opened: {
            var arr = []
            for (var i = 0; i < count; i++)
                arr.push(false)

            return arr
        }

        function setOpened(index, state) {
            if (opened[index] !== state) {
                // close any currently opened element
                var idx = opened.indexOf(true)
                if (idx !== -1)
                    opened[idx] = false

                // update
                opened[index] = state
                openedChanged()
            }
        }

        anchors {
            top: searchBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 20
        }
        clip: true

        model: staticDataModel

        delegate: Item {
            id: element
            width: listView.width; height: header.height + content.height
            clip: true
            state: listView.opened[index] ? "" : "folded"

            Item {
                id: header
                width: parent.width; height: 50

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                    width: parent.width
                    elide: Text.ElideRight
                    color: element.state == "" ? "#0053cd" : "dimgray"
                    font.pointSize: 15
                    textFormat: Text.PlainText
                    text: modelData.name
                }

                Text {
                    anchors {
                        right: parent.right
                        rightMargin: 15
                        verticalCenter: parent.verticalCenter
                    }
                    text: Qt.formatDate(modelData.date, "MMMM d, yyyy")
                    color: "gray"
                    font.pointSize: 14
                }

                Image {
                    source: "../../resources/icons/separator.png"
                    anchors.bottom: parent.bottom
                    width: parent.width
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        hideKeyboard()
                        listView.setOpened(index, !listView.opened[index])
                    }
                }
            }

            Column {
                id: content
                anchors {
                    top: header.bottom
                    left: parent.left
                    right: parent.right
                }
                spacing: 5

                Rectangle {
                    width: parent.width
                    height: image.height + text.height + sep.height * 2
                    color: "#fdfdfe"

                    Image {
                        id: image
                        anchors {
                            top: parent.top
                            horizontalCenter: parent.horizontalCenter
                        }
                        width: 325; height: 325
                        source: "../../resources/" + modelData.view + "/" + modelData.view + "0" + modelData.imageIndex + ".png"
                    }

                    Image {
                        id: sep
                        source: "../../resources/icons/separator.png"
                        anchors.top: image.bottom
                        width: parent.width
                    }

                    Column {
                        id: text
                        anchors {
                            top: sep.bottom
                            left: parent.left
                            right: parent.right
                            leftMargin: 20
                            rightMargin: 20
                        }
                        spacing: 5

                        Item { width: parent.width; height: 1 }

                        Text {
                            width: parent.width
                            text: String(modelData.text).replace(/\s+/g, ' ')
                            wrapMode: Text.Wrap
                            font.pointSize: 12
                            textFormat: Text.PlainText
                            color: "dimgray"
                        }

                        Item { width: parent.width; height: 3 }
                    }


                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideKeyboard()

                            var geometry = {
                                x: parent.mapToItem(null, 0, 0).x,
                                y: image.mapToItem(null, 0, 0).y,
                                w: parent.width,
                                h: image.height
                            }

                            profileChangeRequest(
                                modelData.name,
                                modelData.date,
                                modelData.view,
                                modelData.imageIndex,
                                image.source,
                                geometry
                            );
                        }
                    }

                    Image {
                        source: "../../resources/icons/separator.png"
                        anchors.bottom: parent.bottom
                        width: parent.width
                    }
                }
            }

            states: State {
                name: "folded"
                PropertyChanges { target: element; height: header.height }
                PropertyChanges { target: content; opacity: 0 }
            }

            transitions: Transition {
                reversible: true
                PropertyAnimation { properties: "height,opacity"; duration: 200 }
            }
        }
    }
}
