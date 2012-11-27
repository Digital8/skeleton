###
 * Index Controller
 *
 * Controller for homepage of website
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

d8 = require '../d8'

d8.load('model','users')

# GET
exports.index = (req,res) ->
  #d8.models['users'].find id: 1, (err, results) ->
  if res.locals.objUser.isAuthed() then res.redirect '/dashboard' else res.render 'index'

# GET    
exports.view = (req,res) ->

# GET
exports.add = (req,res) ->

# PUT
exports.create = (req,res) ->

# GET
exports.edit = (req,res) ->

# POST
exports.update = (req,res) ->

# DEL
exports.destroy = (req,res) ->

