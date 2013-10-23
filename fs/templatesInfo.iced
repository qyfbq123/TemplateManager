path = require 'path'
fs = require 'fs'
watch = require 'watch'

config = require '../config.json'

templatesPath = path.resolve __dirname, '..', config.templatesPath

tem = exports = module.exports = {}

tem.init = ->
  self = this
  self.reading = false
  self.categories = []
  tem.readTemplates (allTemplates)->
    console.log allTemplates
    allTemplates.forEach (ele, index)->
      if self.categories.indexOf(ele.category) is -1
        self.categories.push ele.category
    console.log self.categories


tem.readTemplates = (cb)->
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
              _manifest[k] = manifest[k] for k, i in ['name', 'description', 'author', 'maintainer', 'index', 'version']
              if typeof _manifest.category is 'object' and not Array.isArray _manifest.category
                _manifest.category = k for k, v of _manifest.category
                allTemplates.push _manifest
            if done
              allTemplates.sort (a, b)->
                return a.index - b.index
              cb allTemplates
