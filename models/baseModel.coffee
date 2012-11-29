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
    @success = ->
    @error = ->
    @done = ->
      
    if arguments.length is 1 
      @table = "#{@db.prefix}#{arguments[0]}"
    else
      @table = "#{@db.prefix}#{this.constructor.name.toLowerCase()}s"


  ### 
   * @name find
   * Searches the database table for a result by provided credentials
   *
  ###
  
  find: (opts,callback) ->
    values = []
    if typeof opts is 'number'
      values.push opts
      query = "SELECT * FROM #{@table} WHERE #{@column_prefix}id = ?"
      
    else
      query = 'SELECT '
      
      if opts.fields? 
        query += opts.fields.join(', ')
        query += " FROM #{@table}"
      else 
        query += "*  FROM #{@table}"
      
      if opts.where? 
        query += ' WHERE '
        keys = []
        Object.keys(opts.where).forEach (obj) ->
          if obj.match /[\<\>]|like/
            keys.push "#{obj} ?"
          else
            keys.push "#{obj} = ?"
          values.push opts.where[obj]
            
        query += keys.join(' AND ')
          
    # Execute query
    console.log query
    console.log values
    @db.query query, values, (err, results) ->
      if results.length is 1 then results = results.pop()
      callback err, results

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
  
    @db.query query, values, (err, results) ->
      console.log results



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
      
  @success = (callback) -> return (err, results) -> callback(results)