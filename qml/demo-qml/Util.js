function getImgFile(model, index) {
    if (!model)
        return ""

    var path = String(model.folder)
    var basename = path.split("/")
    basename = basename[basename.length-1]

    return path + '/' + basename + Math.max(0, Math.min(Math.round(model.count * index), model.count - 1)) + ".jpg"
}
