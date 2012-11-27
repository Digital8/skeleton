###
 * Base Model class
 *
 * Base model for all children models
 * NOTE: All function methods can be overwritten in child class
 *
 * @package   Digital8
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

mysql =  require 'mysql'
db = require('../d8').db

module.exports = class Model
  
  ### 
   * @name constructor 
   * Setup some base properties for our model
   *
   * @param Nil
  ###

  constructor: ->
    @db = db
    @column_prefix = this.constructor.name.toLowerCase() + '_'
    @table = "#{@db.prefix}#{this.constructor.name.toLowerCase()}s"

  ### 
   * @name findById
   * Searches the database table for a match by ID
   *
   * @param {Integer} id
   * @param {Function} callback
  ###
  
  findById: (id, callback) ->
    query = "SELECT * FROM #{@table} WHERE #{@column_prefix}id = ?"

    # Perform database query
    @db.query query, [id], (err, results) -> callback err, results


  ### 
   * @name find
   * Searches the database table for a result by provided credentials
   *
   * @param {Integer} id
   * @param {Object} options {Optional}
   * 
   *  - `conditions`  Array of fields for conditions
   *  - `values`  Array of values for the previous conditions
   *  - `limit` String of limit range. eg - limit: '5 10'
   *  - `order` String of field name and direction. eg - order: 'user_created DESC'
   *
   * @param {Function} callback
  ###
  
  find: (fields, options, values) ->
    fields = fields.join ','
    query = "SELECT #{fields} FROM #{@table}"
    
    # Check if we're passing any options
    if arguments.length == 3
      conditions = arguments[1]
      callback = arguments[2]

      # Check if we're passing any conditions
      if options.conditions.length >= 1
        i = 0
        # loop through all conditions
        for [i..(options.conditions.length - 1)]
          # Check if to use WHERE or comparison operators
          if i is 0 
            query += " WHERE #{options.conditions[i].field} = ?"
          else
            if options.conditions[i].operator?
              query += " #{options.conditions[i].operator} #{options.conditions[i].field} = ?"
            else
              query += " AND #{options.conditions[i].field} = ?"
          i++

      # Check if we're to order results
      if options.order isnt undefined
        query += " ORDER BY options.order "

      # Any limits
      if options.limit isnt undefined
        query += " LIMIT #{options.limit} "
    else
      options = {}

    options.values ?= []      

    # Execute query
    @db.query query, options.values, (err, results) -> callback err, results



  ### 
   * @name findOne
   * Searches the database table for a ONE result by provided credentials
   *
   * @param {Integer} id
   * @param {Object} options {Optional}
   * 
   *  - `conditions`  Array of fields for conditions
   *  - `values`  Array of values for the previous conditions
   *  - `order` String of field name and direction. eg - order: 'user_created DESC'
   *
   * @param {Function} callback
  ###

  findOne: (fields, options, callback) -> 
    fields = fields.join ','
    query = "SELECT #{fields} FROM #{@table}"
    
    # Check if we're passing any options :)
    if arguments.length == 3
      options.values ?= []
      conditions = arguments[1]
      callback = arguments[2]

      # Check if we're passing any conditions
      if options.conditions.length >= 1
        i = 0
        # loop through all conditions
        for [i..(options.conditions.length - 1)]
          # Check if to use WHERE or comparison operators
          if i is 0 
            query += " WHERE #{options.conditions[i].field} = ?"
          else
            if options.conditions[i].operator?
              query += " #{options.conditions[i].operator} #{options.conditions[i].field} = ?"
            else
              query += " AND #{options.conditions[i].field} = ?"
          i++
      # Check if we're doing an order by
      if options.order isnt undefined
        query += " ORDER BY options.order "
    else
      options = {}

      query += " LIMIT 1 "

    options.values ?= []

    # execute query and return resu;ts
    @db.query query, options.values, (err, results) -> callback err, results
        
      

  ### 
   * @name findAll
   * Searches the database table for all results by provided credentials
   *
   * @param {Integer} id
   * @param {Object} options {Optional}
   * 
   *  - `conditions`  Array of fields for conditions
   *  - `values`  Array of values for the previous conditions
   *  - `order` String of field name and direction. eg - order: 'user_created DESC'
   *
   * @param {Function} callback
  ###

  findAll: (fields, options, callback) -> 
    fields = fields.join ','
    query = "SELECT #{fields} FROM #{@table}"
    
    # Check if we're passing any options 
    if arguments.length == 3
      conditions = arguments[1]
      callback = arguments[2]

      # Check if we're passing any conditions
      if options.conditions.length >= 1
        i = 0
        # Loop through all conditions
        for [i..(options.conditions.length - 1)]
          # Do we have to place original WHERE
          if i is 0 
            query += " WHERE #{options.conditions[i].field} = ?"
          else
            if options.conditions[i].operator?
              query += " #{options.conditions[i].operator} #{options.conditions[i].field} = ?"
            else
              query += " AND #{options.conditions[i].field} = ?"
          i++

      # Order out any output?
      if options.order isnt undefined
        query += " ORDER BY options.order "
    else
      options = {}

    options.values ?= []
    # Execute query
    @db.query query, options.values, (err, results) -> callback err, results



  ### 
   * @name insert
   * Inserts new entry into the database
   *
   * @param {Array} fields
   * @param {Array} values
   * @param {Function} callback
  ###

  insert: (fields, values, callback) ->
    i = 0
    query = "INSERT INTO #{@table} "

    # Get each value and field and append it to the query
    fields = fields.join ','
    query += '(' + fields + ') VALUES('

    for [i..(values.length-1)]

      query += '?'

      # For each of the fields we will have to append a , for valid SQL
      unless i is (values.length-1) then query += ', '
      i++

    # Finish off the query
    query += ")"

    # Perform query
    @db.query query, values, (err, results) -> callback err, results



  ### 
   * @name update
   * Updates the database entry by id
   *
   * @param {Integer} id
   * @param {Array} fields
   * @param {Array} values
   * @param {Function} callback
  ###

  update: (id, fields, values, callback) ->
    i = 0
    query = "UPDATE #{@table} SET "

    # Get each value and field and append it to the query
    for [i..(fields.length-1)]

      value = [fields[i], '?']
      value = value.join '='
      query += value

      # For each of the fields we will have to append a , for valid SQL
      unless i is (fields.length-1) then query += ', '
      i++

    # Merge the arrays fof the query function
    values = values.concat id

    # Finish off the query
    query += " WHERE #{@column_prefix}id = ?"
    
    # Perform query
    @db.query query, values, (err, results) -> callback err, results



  ### 
   * @name delete
   * Sets a deleted flag on an entry. If purge is set to true, it will remove
   * the row from the database
   *
   * @param {Integer} id
   * @param {Bool} purge (Default: false, optional)
   * @param {Function} callback
  ###

  delete: (id, callback) ->
    # See if we're passing in a purge option [argument 2]
    if arguments.length == 3
      # Reposition our parameters to reflect
      purge = arguments[1]
      callback = arguments[2]

      # purge is set, so double check that its true before we delete
      if not purge
        query = "UPDATE #{@table} SET #{@column_prefix}deleted = true WHERE #{@column_prefix}id = ?"
        
        # Perform query
        @db.query query, [id], (err, results) -> callback err, results
      else
        query = "DELETE FROM #{@table} WHERE #{@column_prefix}id = ?"

        # Perform query
        @db.query query, [id], (err, results) -> callback err, results
    else
      query = "UPDATE #{@table} SET #{@column_prefix}deleted = true WHERE #{@column_prefix}}id = ?"
      # Perform query
      @db.query query, [id], (err, results) -> callback err, results