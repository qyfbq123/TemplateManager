path = require 'path'
fs = require 'fs'
config = require '../config.json'

templatesPath = path.resolve __dirname, '..', config.templatesPath

tem = exports = module.exports = {}

tem.init = ->
  this.reading = false

readTemplates = (cb)->
  allTemplates = []
  cb = {} if !cb
  cb.pending = 0 if !cb.pending
  fs.readdir templatesPath, (err, files)->
    cb err if err
    files.forEach (fileName)->
      return if fileName in ['demo4copy', 'API Tests', 'Test-SafeSiteX']
      filePath = path.join templatesPath, fileName
      fs.lstat filePath, (err, stats)->
        return false if err
        if stats.isDirectory()
          cb.pending += 1
          manifestPath = path.join filePath, 'manifest.json'
          fs.exists manifestPath, (exists)->
            cb.pending -= 1
            done = cb.pending is 0
            if exists
              manifest = require manifestPath
              _manifest = {}
              _manifest[k] = manifest[k] for k, i in ['name', 'description', 'author', 'maintainer', 'category', 'index', 'version']
              _manifest.category = k for k, v of _manifest.category
              allTemplates.push _manifest
            if done
              allTemplates.sort (a, b)->
                return a.index - b.index

module.exports.readTemplates = readTemplates
fs.watch templatesPath, (event, filename)->
  console.log "event:#{event} , filename:#{filename}"
module.exports.allTemplates = allTemplates
