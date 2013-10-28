tsInfo = require '../fs/templatesInfo'

tsInfo.init()
exports.all = (req, res)->
  res.json tsInfo.allTemplates

exports.categories = (req, res)->
  res.json tsInfo.categories
