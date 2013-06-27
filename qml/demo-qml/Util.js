function getImgFile(model, index) {
    if (!model)
        return ""

    var path = String(model.folder)
    var basename = path.split("/")
    basename = basename[basename.length-1]

    return path + '/' + basename + padNumber(Math.max(0, Math.min(Math.round(model.count * index), model.count - 1)), 3) + ".png"
}

function padNumber(number, length)
{
    var out = "" + number;
    while (out.length < length) {
        out = "0" + out;
    }

    return out;
}

