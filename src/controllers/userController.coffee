module.exports = (app, User, passportMiddleware) ->
  getCurrent: [(req, res, next) ->
    unless req.user
      res.send 400
    else
      User.findOne
        _id: req.user.id
      , (err, results) ->
        return next(err)  if err
        if results
          console.log username: results.username
          res.send username: results.username
        else
          res.send 400

  ]
  authenticate: [(req, res, next) ->
    passportMiddleware.authenticate("local", (err, user, info) ->
      return next(err)  if err
      return res.send("Invalid username or password.", 400)  unless user
      req.logIn user, (err) ->
        return next(err)  if err
        res.send "Ok", 200

    ) req, res, next
  ]
  create: [(req, res, next) ->
    user = new User(req.body)
    User.findOne
      username: user.username
    , (err, results) ->
      return next(err)  if err
      if results
        res.send "A user with this username already exists.", 400
      else
        user.save (err, results) ->
          return next(err)  if err
          req.logIn user, ->
            res.send "ok", 200
  ]

  #logout/kill session
  kill: [(req, res) ->
    if req.session
      req.session.destroy ->
        res.send "ok", 200

    else
      res.send "ok", 200
  ]
