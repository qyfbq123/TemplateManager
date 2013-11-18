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
app.use express.cookieParser 'some secret'
app.use express.cookieSession()
app.use express.static path.join __dirname, 'public'
app.use express.static path.resolve __dirname, '.', config.templatesPath
app.use app.router

app.configure 'development', ->
  app.use express.errorHandler()

app.all '*', (req, res, next)->
  console.log req.session.message
  if req.session.message
    res.locals.message = req.session.message
    req.session.message = undefined
  next()

app.get '/', routes.index

app.get '/templates/', routes.templates
app.get '/subTemplates/', routes.subTemplates
app.get '/template/', routes.template
app.get '/upload/', routes.goupload
app.get '/template:tid/', routes.templateById

app.get '/template:tid/download/', routes.download
app.post '/template/upload/', routes.upload

app.get '/api/categories/', api.categories

app.all '/api/templates/', api.templates
app.get '/api/templates/category/', api.subTemplates
app.get '/api/templates/recent:number/', api.recentTemplates
app.get '/api/templates/hot:number/', api.hotTemplates

app.get '/api/template:tid/', api.template

 # redirect all others to the index (HTML5 history)
app.get '*', routes.index

app.use (err, req, res, next)->
  # return next err if req.method == 'GET'
  if err
    res.send 500, err.message||String err
  else
    next err

server.listen app.get( 'port' ), ->
  console.log "Express server listening on port #{app.get 'port'}"
