path = require 'path'
fs = require 'fs'
config = require '../config.json'

templatesPath = path.resolve __dirname, '..', config.templatesPath
allTemplates = []

readTemplates = (cb)->
  fs.readdir templatesPath, (err, files)->
    cb err if err
    files.forEach (fileName)->
      return if fileName is 'demo4copy'
      filePath = path.join templatesPath, fileName
      fs.lstat filePath, (err, stats)->
        return false if err
        if stats.isDirectory()
          manifestPath = path.join filePath, 'manifest.json'
          fs.exists manifestPath, (exists)->
            if exists
              manifest = require manifestPath
              allTemplates.push manifest

module.exports.readTemplates = readTemplates
fs.watch templatesPath, (event, filename)->
  console.log "event:#{event} , filename:#{filename}"
module.exports.allTemplates = allTemplates
