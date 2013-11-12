db = require './db'
db.addTemplate (a:'223'), (e, a)->
  console.log a
db.getAllTemplates (e, arr)->
