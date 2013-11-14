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
    err = null
    if code != 0
      err = new Error 'Some error occurs when packing templates!'
    else
      fs.renameSync _tempPath, archivePath

    fs.renameSync targetMain, originalMain
    
    cb err if cb

getCategory = (category)->
  if typeof category is 'object' and not Array.isArray category
    return k for k, v of category
  else if !category
    return 'Other'
  return null

extractManifest = (manifest, _manifest)->
  _manifest = _manifest || {}
  _manifest.feature = '测试'
  _manifest[k] = manifest[k] for k, i in ['name', 'description', 'author', 'maintainer', 'category', 'index', 'version', 'require']
  _manifest._category = getCategory manifest.category
  return _manifest

exports.readTemplatesDirectory = (cb)->
  return cb() if not fs.existsSync archivePath

  allTemplates = []
  fs.readdir archivePath, (err, files)->
    cb err if err
    files.forEach (name)->
      return if path.extname(name) isnt '.zip'

      filepath = path.join archivePath, name
      zf = new zipfile.ZipFile filepath
      buffer = null
      zf.names.some (_name)->
        if _name.indexOf('manifest') isnt -1
          buffer = zf.readFileSync _name
          return true
      return if !buffer #若找不到manifest文件，直接返回
      manifest = JSON.parse buffer.toString().replace /\s+/g, ''

      _manifest = extractManifest manifest
      _manifest.filename = name
      _manifest.filepath = filepath

      _stat = fs.lstatSync(path.join archivePath, name)
      _manifest.size = _stat.size.toString()

      _manifest.created = _manifest.updated = _stat.mtime.getTime().toString()
      _manifest.download = 0
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

  return cb new Error 'No file named manifest.json in the zip file!' if !buffer

  manifest = JSON.parse buffer.toString().replace /\s+/g, ''

  _manifest = extractManifest manifest
  _stat = fs.lstat filepath, (e, _stat)->
    _manifest.size = _stat.size.toString()

    cb null, _manifest
