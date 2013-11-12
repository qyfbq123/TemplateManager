
templates = require('./main').templates

exports.add = (template, cb)->
  templates.insert template, cb

exports.findOne

exports.all = (cb)->
  templates.find().toArray cb

exports.clear = ()->
  templates.drop ->
