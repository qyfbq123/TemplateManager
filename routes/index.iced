path = require 'path'
fs= require 'fs'

ObjectID = require('mongoskin').ObjectID

db = require '../db'
_fs = require '../fs'
config = require '../config.json'

exports.index = (req, res)->
  res.render 'index'

exports.templates = (req, res)->
  res.render 'partials/templates'

exports.subTemplates = (req, res)->
  res.render 'partials/subTemplates'

exports.template = (req, res)->
  res.render 'partials/template'

exports.goupload = (req, res)->
  res.render 'partials/upload'

exports.templateById = (req, res)->
  console.log 'here'
  

exports.upload = (req, res, next)->
  zipFile = req.files.zipFile
  if zipFile && zipFile

    return next new Error '只接受.zip格式的压缩文件！' if path.extname(zipFile.name) isnt '.zip'
    _fs.readTemplate zipFile.path, (e, manifest)->
      return next e if e
      db.findOne (name: manifest.name, author: manifest.author), (e, t)->
        if t
          if t.version >= manifest.version
            return next new Error '上传失败！不可以上传低版本模板。'
          t[k] = manifest[k] for k in ['version', 'description', 'maintainer', 'category', 'index', 'version', 'require']
          t.filename = zipFile.name
          t.history.push manifest.version
          t.updated = new Date().getTime().toString()

          db.save t, (e)->
            return next e if e
            fs.unlink t.filepath, (e)->
              return next e if e
              fs.rename zipFile.path, path.join(config.archivePath, "#{t._id.toHexString()}_#{zipFile.name}"), (e)->
                req.session.message = '上传成功'
                res.redirect 'back'
        else
          manifest.filename = zipFile.name
          manifest.created = manifest.updated = new Date().getTime().toString()
          manifest.download = 0
          manifest.history = [ manifest.version ]

          db.save manifest, (e, t)->
            return next e if e

            pathname =  path.join config.archivePath, "#{t._id.toHexString()}_#{t.filename}"
            t.filepath = pathname
            db.save t, ->
              return next e if e
              fs.rename zipFile.path, pathname, (e)->
                return next e if e
                req.session.message = '上传成功'
                res.redirect 'back'


exports.download = (req, res, next)->
  db.findOne '_id': ObjectID.createFromHexString(req.params.tid), (err, t)->
    return next err if err

    if !t
      res.send 500, 'Error!下载出错!' 
    else
      t.download += 1
      db.save t, (e)->
      res.download t.filepath, t.filename
