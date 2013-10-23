watch = require 'watch'
path = require 'path'

config = require './config.json'
root = path.resolve __dirname, '.', config.templatesPath

filter = (f, stat)->
  #console.log f
  return stat.isFile() && f.indexOf('manifest.json') is -1

a = ('Google+': 123)
console.log a

watch.watchTree root, (ignoreDotFiles: true), (f, curr, prev)->
  if typeof f is "object" and prev is null && curr is null
    #console.log 'end'
    arr = Object.keys f
    arr.forEach (elem, index)->
      #console.log elem
      #console.log elem if elem.indexOf('manifest.json') >= 0
  else if prev is null
    # f is a new file
    console.log 'new file:' + f
  else if curr.nlink is 0
    # f was removed
    console.log 'removed'
  else
    console.log 'changed'
