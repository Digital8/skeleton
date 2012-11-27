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

d8.load('helper','restrictTo')
d8.load('model','user')

module.exports = 
  index: (req,res) ->
    d8.models['user'].findById 1, (err, results) ->
      if err
        res.send err
      else
        res.send results
    
  view: (req,res) ->

  add: (req,res) ->

  create: (req,res) ->

  edit: (req,res) ->

  update: (req,res) ->

  destroy: (req,res) ->

