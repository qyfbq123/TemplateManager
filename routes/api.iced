db = require '../db'

exports.templates = (req, res)->
  db.all (e, templates)->
    res.json templates

exports.categories = (req, res)->
  db.categories (e, categories)
    res.json categories

exports.subTemplates = (req, res)->
  db.find '_category': req.params.category, (e, templates)->
    res.json templates

exports.template = (req, res)->
  db.findOne '_id': req.params.tid, (e, template)->
    res.json template
