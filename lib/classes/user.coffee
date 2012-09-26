###
 * User class
 *
 * Creates an object of the users credentials
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

accountLevel = require('../../system').config.acl

module.exports = class User
	constructor: (userData) ->
	  userData.admin_rights ?= ''

	  # Properties
	  @id = userData.user_id or 0
	  @alias = userData.alias or 'Guest'
	  @firstName = userData.first_name or ''
	  @lastName = userData.last_name or ''
	  @displayName = "#{@firstName} #{@lastName}" or ''
	  @email = userData.email or ''
	  @level = userData.acl or 0
	  @funds = userData.funds or 0
	  @notes = userData.admin_notes or ''
	  @rights = userData.admin_rights.split '.'
	  @avatar = if userData.photo  then "/uploads/#{userData.photo}" else 'http://placehold.it/150x150'
	
	isMember: ->
	  return (@level >= accountLevel.member) ? true : false
	
	isExpert: ->
	  return (@level >= accountLevel.expert) ? true : false
	
	isStaff: ->
	  return (@level >= accountLevel.staff) ? true : false
	
	isAdmin: ->
	  return (@level == accountLevel.admin) ? true : false

	isBanned: ->
	   return (@level == accountLevel.banned) ? true : false
	   
	isOwner: (owner_id) ->
	  
	  if @id == owner_id
	    return true
	  else if @isAdmin()
	    return true
	  else 
	    return false
	    
	isAuthed: ->
	  if @id is 0 then return false else return true
	  
	checkRights: (right) ->
	  if @isAdmin() 
	    return true
	  else
	    if not right?
	      return @userRights.length
	    else
  	    authorized = false
  	    for priv in @rights
  	      if priv == right
  	        authorized = true
  	        break
	        
	    return authorized
