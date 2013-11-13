path = require 'path'
fs = require 'fs'
zipfile = require 'zipfile'
{
  spawn 
} = require 'child_process'

config = require '../config.json'

templatesPath = path.resolve __dirname, '..', config.templatesPath
archivePath = path.resolve __dirname, '..', config.archivePath
if !fs.existsSync _tempPath = path.join templatesPath, '_temp'
  fs.mkdirSync _tempPath

# tem.init = ->
#   self = this
#   self.reading = false
#   self.categories = []
#   tem.readTemplates (e)->

#     self.allTemplates.sort (a, b)->
#       if !a.index && !b.index
#         return 0
#       else if !a.index
#         return 1
#       else if !b.index
#         return -1
#       return a.index - b.index
#     self.allTemplates.forEach (ele, index)->
#       ele.id = index
#       if self.categories.indexOf(ele._category) is -1
#         self.categories.push ele._category

# tem.getTemplateById = (id)->
#   template = null
#   this.allTemplates.some (ele, index)->
#     if ele.id == Number id
#       template = ele
#       return true

#   return template

# tem.getTemplatesByCategory = (category)->
#   return tem.allTemplates.filter (ele, index)->
#     return ele._category == category

deleteFolderRecursive = (path)->
  files = []
  if fs.existsSync path
    files = fs.readdirSync path
    files.forEach (file,index)->
      curPath = path + "/" + file
      if fs.statSync(curPath).isDirectory()
        deleteFolderRecursive curPath
      else
        fs.unlinkSync curPath
    fs.rmdirSync path

exports.archive = (cb)->
  deleteFolderRecursive _tempPath
  deleteFolderRecursive archivePath
  originalMain = path.join __dirname, 'main.sh'
  targetMain = path.join templatesPath, 'main.sh'

  fs.renameSync originalMain, targetMain
  _zip = spawn "./main.sh", [],
    cwd: templatesPath
    stdio: 'inherit'
  _zip.on 'close', (code)->
    if code != 0
      console.log 'Some error occurs when packing templates!'
    else
      fs.renameSync _tempPath, archivePath
      cb() if cb
    fs.renameSync targetMain, originalMain

getCategory = (category)->
  if typeof category is 'object' and not Array.isArray category
    return k for k, v of category
  else if !category
    return 'Other'
  return null

exports.readTemplatesDirectory = (cb)->
  return cb() if not fs.existsSync archivePath

  allTemplates = []
  fs.readdir archivePath, (err, files)->
    cb err if err
    files.forEach (name)->
      return if path.extname(name) isnt '.zip'

      zf = new zipfile.ZipFile path.join archivePath, name
      buffer = null
      zf.names.some (_name)->
        if _name.indexOf('manifest') isnt -1
          buffer = zf.readFileSync _name
          return true
      manifest = JSON.parse buffer.toString().replace /\s+/g, ''

      _manifest = filename: name
      _manifest.feature = '测试'
      _stat = fs.lstatSync(path.join archivePath, name)
      _manifest.size = _stat.size.toString()
      _manifest.updated = _manifest.created = _stat.mtime.getTime().toString()

      _manifest[k] = manifest[k] for k, i in ['name', 'description', 'author', 'maintainer', 'category', 'index', 'version', 'require']
      _manifest._category = getCategory manifest.category

      _manifest.history = [ manifest.version ]
      
      allTemplates.push _manifest  if _manifest._category

    allTemplates.sort (a, b)->
      if !a.index && !b.index
        return 0
      else if !a.index
        return 1
      else if !b.index
        return -1
      return a.index - b.index
    cb err, allTemplates

exports.readTemplate = (filepath, cb)->
  return if path.extname(filepath) isnt '.zip'

  zf = new zipfile.ZipFile filepath
  buffer = null
  zf.names.some (name)->
    if name.indexOf('manifest') isnt -1
      buffer = zf.readFileSync name
      return true
  manifest = JSON.parse buffer.toString().replace /\s+/g, ''

  _manifest = filename: path.basename filepath
  _manifest.feature = '测试'
  _stat = fs.lstatSync filepath
  _manifest.size = _stat.size.toString()
  _manifest[k] = manifest[k] for k, i in ['name', 'description', 'author', 'maintainer', 'category', 'index', 'version', 'require']
  _manifest._category = getCategory manifest.category

  cb _manifest
