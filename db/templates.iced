
templates = require('./main').templates

exports.add = (template, cb)->
  templates.insert template, cb

exports.findOne = (options, cb)->
  templates.findOne options, cb

exports.all = (cb)->
  templates.find().toArray cb

exports.clear = (cb)->
  templates.drop (e)->
    cb e

exports.update = (template, cb)->
	templates.update template, cb
exports.categories = (cb)->
  templates.distinct '_category', cb
