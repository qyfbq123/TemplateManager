
templates = require('./main').templates

exports.add = (template, cb)->
  templates.insert template, cb

exports.find = (options, cb)->
  templates.find.apply templates, arguments

exports.findOne = (options, cb)->
  templates.findOne.apply templates, arguments

exports.clear = (cb)->
  templates.drop (e)->
    cb e

exports.save = (template, cb)->
  templates.save template, cb
  
exports.categories = (cb)->
  templates.distinct '_category', cb
