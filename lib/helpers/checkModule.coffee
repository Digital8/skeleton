###
 * Check Module
 *
 * Helper to check if a specific module is activated/de-activated from configuration.
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../../system'

module.exports = (module) ->
  (req,res,next) ->
    if system.config.modules?[module] is true
      next()
    else
      res.render 'errors/deactivated'