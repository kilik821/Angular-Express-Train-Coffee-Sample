hbs = require("express-hbs")
path = require("path")
module.exports = (app) ->
  
  #set up view engine
  app.set "views", process.cwd() + "/views"
  app.set "view engine", "jade"
  # Static locals
  app.locals {}
