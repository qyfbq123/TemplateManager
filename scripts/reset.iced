db = require '../db'
_fs = require '../fs'
config = require '../config'
main = require '../db/main'

console.log '刷新开始'
db.clear (e)->
  _fs.archive (e)->
    _fs.readTemplatesDirectory (e, templates)->
      db.add templates, (e)->
        main.close (e)->
          console.log '刷新结束'
