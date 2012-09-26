###
 * Hash Helper
 *
 * Helper to quickly generate and return a hash
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
crypto = require 'crypto'

module.exports = (msg) ->
  crypto.createHmac('sha256', 'TimeForAdviceSalt').update(msg).digest('hex')