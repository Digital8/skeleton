###
 * Invert Helper
 *
 * Helper to quickly invert an object keys & values
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

module.exports = (obj) ->
  newObject = {}
  keys = Object.keys(obj)
  
  for key in keys
    newObject[obj[key]] = key
  

  return newObject