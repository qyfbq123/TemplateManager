zipfile = require 'zipfile'
path = require 'path'
fs = require 'fs'
db = require './db'
templates = require './fs/templates'


templates.readTemplate './templates/BaiduBlog.zip', (a)->
  console.log a
