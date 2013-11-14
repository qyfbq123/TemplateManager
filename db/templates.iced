
templates = require('./main').templates

exports.add = (template, cb)->
  templates.insert template, cb

exports.find = (options, cb)->
  if arguments.length is 3
    templates.find(arguments[0], arguments[1]).toArray arguments[2]
    return
  templates.find(options).toArray cb

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
