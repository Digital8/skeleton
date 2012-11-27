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

module.exports = (app) ->
  # Load in the controllers
  controllers = {}

  fs.readdir __dirname + "/controllers", (err, files) -> 
    for file in files
      loadController app, file
      #controllers[module.split('.')[0]] = require("./controllers/" + file)
  
  loadController = (app, file) ->
    name = file.replace '.coffee', ''
    actions = require './controllers/' + name
    plural = name + 's'
    prefix = '/' + plural

    if name == 'app' or name == 'index' then prefix = '/' # For our routes

    Object.keys(actions).map (action) ->
      fn = controllerAction name, plural, action, actions[action]
      switch action
        when 'index' then app.get prefix, fn
        when 'view' then app.get prefix + '/:id.:format?', fn
        when 'add' then app.get prefix + '/add', fn
        when 'create' then app.post prefix, fn
        when 'edit' then app.get prefix + '/:id/edit', fn
        when 'update' then app.put prefix + '/:id', fn
        when 'destroy' then app.del prefix + '/:id', fn
        else app.get prefix, fn
        
  controllerAction = (name, plural, action, fn) ->
    (req, res, next) ->
      render = res.render
      format = req.params.format
      if name is 'index'
        path = __dirname + '/views/' + action + d8.config.viewExt
      else
        path = __dirname + '/views/' + name + '/' + action + d8.config.viewExt

      res.render = (obj, options, fn) ->
        res.render = render;

        ## Template path
        if typeof obj is 'string'
          res.render obj, options, fn

        ## Format support
        if action == 'view' && format?
          if format is 'json'
            res.send obj
          else 
            throw new Error 'unsupported format "' + format + '"'

        unless format
          ## Render template
          res.render = render
          options = options || {}

          ## Expose obj as the "users" or "user" local
          if action == 'index' 
            options[plural] = obj
          else
            options[name] = obj

          res.render path, options, fn

      fn.apply this, arguments