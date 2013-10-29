path =require 'path'

templates = require '../fs/templates'
config = require '../config.json'

templates.init()
exports.templates = (req, res)->
  res.json templates.allTemplates

exports.categories = (req, res)->
  res.json templates.categories

exports.download = (req, res)->
  t = templates.getTemplateById req.params.tid
  zipPath = path.resolve __dirname, '..', config.templatesPath, '_temp', t.dirName + '.zip'
  res.download zipPath, t.dirName + '.zip'

exports.subTemplates = (req, res)->
  res.json templates.getTemplatesByCategory req.params.category

exports.templatesSortByCategory = (req, res)->
  res.json templates.categories.map (c)->
    _temp = category: c
    _temp.templates = templates.getTemplatesByCategory c
    _temp.templates = _temp.templates.slice 0, 2 if _temp.templates.length > 2
    return _temp
