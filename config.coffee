###
 * Configuration
 *
 * Application Settings
 *
 * @package   Digital8 <http://digital8.com.au>
 * @version   2.0.1
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

logDate = new Date();

module.exports =
  globals:
    site:
      name: 'Digital8 Skeleton'

  database:
    type    : 'mysql'
    host    : 'localhost'
    user    : ''
    password: ''
    name    : ''
    prefix  : ''
  
  logFile   : "./logs/#{logDate.getDay()}#{logDate.getMonth()}#{logDate.getFullYear()}.txt"
    
  port: 3000
