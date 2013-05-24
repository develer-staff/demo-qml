function getImgFile(model, index) {
    var path = String(model.folder)
    var basename = path.split("/")
    basename = basename[basename.length-1]

    return path + '/' + basename + Math.round(model.count * index) + ".jpg"
}
