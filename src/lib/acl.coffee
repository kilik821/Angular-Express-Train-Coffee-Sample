mongoose = require "mongoose"
acl = require "acl"
module.exports = (dal) ->

  new acl new acl.mongodbBackend dal