import QtQuick 2.0
import "Keyboard.js" as KB

Loader {
    id: keyboardLauncher
    state: "hide"

    property EditBox target

    Component {
        id: kbd
        Keyboard {
            onKeyPressed: keyboardLauncher.processKey(code, type)
            onClosed: keyboardLauncher.state = "hide"
        }
    }

    function processEditRequest(tgt) {
        if (!sourceComponent) {
            sourceComponent = kbd
            state = ""
        }
        target = tgt
    }

    function processKey(code, type) {
        switch (type) {
        case KB.KeyType.CHARACTER:
            target.text = target.text + code
            break

        case KB.KeyType.SPACE:
            target.text = target.text + " "
            break

        case KB.KeyType.BACKSPACE:
            target.text = target.text.slice(0, target.text.length - 1)
            break
        }
    }

    states: State {
        name: "hide"
        PropertyChanges { target: keyboardLauncher; height: 0; opacity: 0 }
    }

    transitions: Transition {
        from: "hide"
        reversible: true

        onRunningChanged: {
            if (!running && keyboardLauncher.height == 0) {
                keyboardLauncher.sourceComponent = undefined
                target.unsetFocus()
            }
        }

        PropertyAnimation { target: keyboardLauncher; properties: "height,opacity"; duration: 200 }
    }
}
