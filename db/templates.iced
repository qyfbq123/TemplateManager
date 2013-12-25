
templates = require('./main').templates

exports.add = (template, cb)->
  templates.insert template, cb

exports.find = ->
  templates.find.apply templates, arguments

exports.findOne = ->
  templates.findOne.apply templates, arguments

exports.clear = (cb)->
  templates.drop (e)->
    cb e

exports.save = (template, cb)->
  templates.save template, cb
  
exports.categories = (cb)->
  templates.aggregate [
    $project:
      _category: 1
  ,
    $sort:
      created: 1
  ,
    $group:
      _id:
        category: "$_category"
      count:
        $sum: 1
  ], cb