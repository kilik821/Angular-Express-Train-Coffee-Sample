passport = require("passport")
LocalStrategy = require("passport-local").Strategy
BAD_LOGIN_STRING = "Invalid username or password"
module.exports = (app, User) ->
  strategy = new LocalStrategy(
    usernameField: "username"
    passwordField: "password"
  , (username, password, done) ->
    console.log "starting local strategy"
    User.findOne
      username: username
    , (err, user) ->
      console.log "user = " + user
      return done(err)  if err
      unless user
        return done(null, false,
          message: BAD_LOGIN_STRING
        )
      if user.authenticate(password)
        done null, user
      else
        done null, false,
          message: BAD_LOGIN_STRING


  )
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done err, user


  passport.use strategy
  passport.setLocals = (req, res, next) ->
    res.locals.user = req.user  if req.isAuthenticated()
    next()

  passport
