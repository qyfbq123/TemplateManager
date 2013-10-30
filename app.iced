express = require 'express'
http = require 'http'
path = require 'path'

routes = require './routes'
api = require './routes/api'
config = require './config.json'

app = module.exports = express()
server = require('http').createServer app

app.set 'port', process.env.PORT || 3000
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.static path.join __dirname, 'public'
app.use express.static path.resolve __dirname, '.', config.templatesPath
app.use app.router

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', routes.index

app.get '/templates/', routes.templates
app.get '/subTemplates/', routes.subTemplates

app.get '/template:tid/download/', api.download

app.get '/api/categories/', api.categories
app.get '/api/templates/sort/', api.templatesSortByCategory

app.all '/api/templates/', api.templates
app.get '/api/templates/:category/', api.subTemplates

 # redirect all others to the index (HTML5 history)
app.get '*', routes.index

server.listen app.get( 'port' ), ->
  console.log "Express server listening on port #{app.get 'port'}"
