###
 * D8
 *
 * Core component to application.
 * The general go-to file to load in resources required
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
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

class D8

  @config = config
  @models = {}
  @class = {}
  @helpers = {}

  @db =
    prefix: config.database.prefix

  # Give our loader some methods to load in specific resources
  @load = (type, file) ->
    switch type
      when 'model' then @helpers[file] = require "./lib/models/#{file}"
      when 'class' then @helpers[file] = require "./lib/classes/#{file}"
      when 'helper' then @helpers[file] = require "./lib/helpers/#{file}"
      else console.log "Warning: No function to load #{type}: #{file}"
    # model: (model) ->
    #   require './models/' + model
    #   
    # class: (className) ->
    #   require './lib/classes/' + className
    #   
    # helper: (helper) ->
    #   require './lib/helpers/' + helper