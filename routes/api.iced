db = require '../db'
ObjectID = require('mongoskin').ObjectID
fields = require './fields'

exports.templates = (req, res, next)->
  db.find {}, fields.templates,(e, _cursor)->
    return next e if e
    _cursor.toArray (e, templates)->
      return next e if e
      res.json templates

exports.categories = (req, res, next)->
  db.categories (e, categories)->
    return next e if e
    res.json categories

exports.subTemplates = (req, res, next)->
  db.find '_category': req.query.category, (e, _cursor)->
    return next e if e
    _cursor.toArray (e, templates)->
      return next e if e
      res.json templates

exports.template = (req, res, next)->
  db.findOne '_id': ObjectID.createFromHexString(req.params.tid), fields.template, (e, template)->
    return next e if e
    res.json template

exports.recentTemplates = (req, res, next)->
  db.find {}, (limit: Number(req.params.number), sort: updated: -1), (e, _cursor)->
    return next e if e
    _cursor.toArray (e, templates)->
      return next e if e
      res.json templates

exports.hotTemplates = (req, res, next)->
  db.find {}, (limit: Number(req.params.number), sort: download: -1), (e, _cursor)->
    return next e if e
    _cursor.toArray (e, templates)->
      return next e if e
      res.json templates
