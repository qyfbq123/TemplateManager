path = require 'path'
fs = require 'fs'
watch = require 'watch'
AdmZip = require 'adm-zip'

config = require '../config.json'

tem = exports = module.exports = {}

templatesPath = path.resolve __dirname, '..', config.templatesPath
if !fs.existsSync _tempPath = path.join templatesPath, '_temp'
  fs.mkdirSync _tempPath

tem.init = ->
  self = this
  self.reading = false
  self.categories = []
  tem.readTemplates (e)->

    self.allTemplates.sort (a, b)->
      if !a.index && !b.index
        return 0
      else if !a.index
        return 1
      else if !b.index
        return -1
      return a.index - b.index
    self.allTemplates.forEach (ele, index)->
      ele.id = index
      if self.categories.indexOf(ele._category) is -1
        self.categories.push ele._category

      templatePath = path.resolve templatesPath, ele.dirName
      zipPath = path.join _tempPath, ele.dirName + '.zip'
      zip = new AdmZip()
      zip.addLocalFolder templatePath
      zip.writeZip zipPath

tem.readTemplates = (cb)->

  this.allTemplates = allTemplates = []
  
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
              _manifest = dirName: fileName
              _manifest[k] = manifest[k] for k, i in ['name', 'description', 'author', 'maintainer', 'category', 'index', 'version']
              if typeof manifest.category is 'object' and not Array.isArray manifest.category
                _manifest._category = k for k, v of manifest.category
              else if !manifest.category
                _manifest._category = 'Other'
              allTemplates.push _manifest  if _manifest._category
            cb() if done

tem.getTemplateById = (id)->
  template = null
  this.allTemplates.some (ele, index)->
    if ele.id == Number id
      template = ele
      return true

  return template

tem.getTemplatesByCategory = (category)->
  return tem.allTemplates.filter (ele, index)->
    return ele._category == category
