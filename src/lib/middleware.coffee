express = require("express")
MongoStore = require("connect-mongo")(express)
connect_timeout = require("connect-timeout")
assets = require("connect-assets")

# Middleware
module.exports = (app, config, passportMiddleware) ->
  
  # Sessions
  mongoStore = new MongoStore(url: config.mongodb.uri)
  session_middleware = express.session(
    key: config.session.key
    secret: config.session.secret
    store: mongoStore
  )
  
  # Error handler
  error_middleware = express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
  
  # Middleware stack for all requests
  app.use assets({src: 'public'})
  app.use express["static"](process.cwd() + '/public') # static files in /public
  app.use connect_timeout(time: config.request_timeout) # request timeouts
  app.use express.cookieParser() # req.cookies
  app.use session_middleware # req.session
  app.use express.bodyParser() # req.body & req.files
  app.use express.methodOverride() # '_method' property in body (POST -> DELETE / PUT)
  app.use passportMiddleware.initialize()
  app.use passportMiddleware.session()
  app.use passportMiddleware.setLocals
  app.use app.router # routes in lib/routes.js
  
  # Handle errors thrown from middleware/routes
  app.use error_middleware
  app.configure "development", ->
    require("express-trace") app

