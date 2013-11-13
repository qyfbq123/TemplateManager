path =require 'path'

templates = require '../fs/templates'
db = require '../db'
config = require '../config.json'

exports.templates = (req, res)->
  db.all (e, templates)->
    res.json templates

exports.categories = (req, res)->
  db.categories (e, categories)
    res.json categories

exports.download = (req, res)->
  db.findOne '_id': req.params.tid, (e, t)->
    if !t
      res.status
      res.send 'Error!下载出错!' 
    else 
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

exports.template = (req, res)->
  res.json templates.getTemplateById req.params.tid
