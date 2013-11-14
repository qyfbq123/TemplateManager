path = require 'path'
fs= require 'fs'

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

exports.upload = (req, res)->
	zipFile = req.files.zipFile
	if zipFile && zipFile
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

					db.update t, (e)->
						return next e if e
						fs.unlink t.filepath, (e)->
							return next e if e
							fs.rename zipFile.path, path.join config.archivePath, "#{t._id.toHexString()}_#{zipFile.name}", (e)->
								next e
				else
					manifest.filename = zipFile.name
					manifest.created = manifest.updated = new Date().getTime().toString();
					manifest.history = [ manifest.version ]

					db.add manifest, (e, t)->
						return next e if e

						pathname =  path.join config.archivePath, "#{t._id.toHexString()}_#{t.filename}"
						manifest.filepath = pathname
						db.update manifest, ->
						fs.rename zipFile.path, pathname, (e)->
							next e


exports.download = (req, res)->
  db.findOne '_id': req.params.tid, (e, t)->
  	next e if e

    if !t
      res.send 500, 'Error!下载出错!' 
    else
      res.download t.filepath, t.filename
