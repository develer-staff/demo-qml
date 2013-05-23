var KeyType = {
    CHARACTER: 0,
    SHIFT: 1,
    SPACE: 2,
    ENTER: 3,
    BACKSPACE: 4
}

function Key(label, type, code) {
    this.label = label
    this.icon = ""
    this.type = type || KeyType.CHARACTER
    this.code = code || label
}

function genCharKeySet(keynames) {
    var row = []
    for (var i = 0; i < keynames.length; i++)
        row.push(new Key(keynames[i].toUpperCase()))

    return row
}

function makeCharsLayout() {
    var shift, backspace, space
    var topRow = genCharKeySet("qwertyuiop")
    var midRow = genCharKeySet("asdfghjkl")
    var lowRow = genCharKeySet("zxcvbnm")

    lowRow.splice(0, 0, new Key("SHIFT", KeyType.SHIFT))
    lowRow.splice(lowRow.length, 0, new Key("BACKSPACE", KeyType.BACKSPACE))

    return [topRow, midRow, lowRow, [new Key("SPACE", KeyType.SPACE)]]
}

var charsLayout = makeCharsLayout()
var digitsLayout = []

var layout = charsLayout
