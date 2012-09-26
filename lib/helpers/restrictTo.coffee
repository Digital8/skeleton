###
 * RestrictTo Helper
 *
 * Helper to restrict a page to specific ACL
 *
 * @package   Digital8
 * @author    Brendan Scarvell <bscarvell@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

module.exports = (acl) ->
  (req,res,next) ->
    if res.locals.objUser.level is acl or res.locals.objUser.isAdmin()
      next()
    else
      res.render 'errors/404'