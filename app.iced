express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'

app = module.exports = express()
server = require('http').createServer app

templatesPath = '/Users/qian/templates'

app.set 'port', process.env.PORT || 3000
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.static path.join __dirname, 'public'
app.use express.static templatesPath, (redirect: false)
app.use app.router

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', routes.index

server.listen app.get( 'port' ), ->
  console.log "Express server listening on port #{app.get 'port'}"
