stage = null

express = require 'express'
http = require 'http'
path = require 'path'

app = express()

initRoutes = ->
  # init the routes
  require('./routes').init app
  initHTTPServer()

initHTTPServer = ->
  # starts the http server
  date = new Date()
  dateStr = date.getHours()%12 + "." + date.getMinutes() + "." + date.getSeconds()

  http.createServer(app).listen app.get('port'), ->
    console.log 'Express server listening on port ' + app.get('port') + " ver: " + dateStr

initApp = do ->
  app.set 'port', process.env.PORT || 3000
  app.use express.logger 'dev'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.methodOverride()
  app.use express.bodyParser()

  if 'development' == app.get 'env'
    app.use express.errorHandler()

  initRoutes()
