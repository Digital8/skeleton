###
 * D8
 *
 * Core component to application.
 * The general go-to file to load in resources required
 *
 * @package   Digital8
 * @version   2.0.1
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
mysql = require 'mysql'
fs = require 'fs'
config = require './config'
db = ( ->
  mysqlClient = mysql.createConnection(
    host     : config.database.host,
    user     : config.database.user,
    password : config.database.password,
    database : config.database.name 
  )
)()

module.exports = class D8

  # General Properties for D8
  @config = config
  @models = {}
  @class = {}
  @helpers = {}
  
  # DB access to our D8 object
  @db = db
  @db.prefix = config.database.prefix

  # Give our loader some methods to load in specific resources
  @load = (type, file) ->
    switch type
      when 'model' then @models[file] = require "./models/#{file}"
      when 'class' then @class[file] = require "./lib/classes/#{file}"
      when 'helper' then @helpers[file] = require "./lib/helpers/#{file}"
      else console.log "Warning: No function to load #{type}: #{file}"
      
  # Render just a view     
  @render = (view) ->
    return (req, res) -> res.render view    
          
  @log = (msg) ->
    date = new Date();
    if arguments.length == 1
      console.log msg
    else
      callback = arguments[1]
      fs.appendFile @config.logFile, "[#{date.getDay()}/#{date.getMonth()}/#{date.getFullYear()}@#{date.getHours()}:#{date.getMinutes()}:#{date.getSeconds()}] - #{msg}\r\n", (err) ->
        if err then console.log "LOG ERROR: #{err}"
        callback()    