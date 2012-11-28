###
 * Server
 *
 * Application Server
 *
 * @package   Digital8
 * @version   2.0.1
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
express = require 'express'
expressValidator = require 'express-validator'
flashify = require 'flashify'

# Include system core
d8 = require './d8'

app = express()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use expressValidator
  app.use express.cookieParser('secretsecret')
  app.use express.session()
  app.use flashify
  app.use express.static "#{__dirname}/public"
  
  # Custom Middleware
  app.use (req,res,done) ->
    res.locals.globals = d8.config.globals
    res.locals.socketio = d8.config.socketio.client
    done()
    
  app.use app.router
  
server = app.listen d8.config.port


# Application routes
require('./routes')(app)

# socket.io
io = require('socket.io').listen server
io.set 'log level', 1

io.sockets.on 'connection', (socket) ->
    
console.log "Server started on port #{d8.config.port}"

