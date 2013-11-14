zipfile = require 'zipfile'
path = require 'path'
fs = require 'fs'
db = require './db'
templates = require './fs/templates'


templates.readTemplatesDirectory (e, a)->
  console.log a
