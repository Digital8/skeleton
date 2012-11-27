###
 * Routes
 *
 * Binds the website routes to specific actions in controllers
 *
 * @package   Digital8
 * @version   2.0.1
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
d8 = require './d8'
fs = require 'fs'

# Load in the controllers
controllers = {}

fs.readdirSync("./controllers").forEach (module) -> 
  controllers[module.split('.')[0]] = require("./controllers/" + module)

# Load in the helpers
d8.load('helper','requireAuth')
d8.load('helper','checkRights')
d8.load('helper','restrictTo')

# Routes for Application
module.exports = (app) ->
  # index
  app.get '/', controllers.index.index