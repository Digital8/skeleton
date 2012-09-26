###
 * Configuration
 *
 * Application Settings
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
module.exports =
  globals:
    site:
      name: 'Digital8 Skeleton'

  database:
    type    : 'mysql'
    host    : '[change me]'
    user    : '[change me]'
    password: '[change me]'
    name    : '[change me]'
    prefix  : '[change me]'
  
  modules:
    login     : true
    register  : true
    questions : true
  
  acl:
    banned : 102
    member : 103
    expert : 104
    staff  : 105
    admin  : 106
    
  port: 3000