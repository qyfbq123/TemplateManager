zipfile = require 'zipfile'
path = require 'path'
fs = require 'fs'
db = require './db'
_fs = require './fs'
templates = require './fs/templates'

db.categories (err, r)->
  console.log err if err
  console.log r

