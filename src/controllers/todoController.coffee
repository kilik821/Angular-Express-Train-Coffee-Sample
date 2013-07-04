module.exports = (app, Todo) ->
  controller = {}
  controller.preSearch = [(req, res, next) ->
    console.log "this it?"
    req.query = userId: req.user.id
    req.Model = Todo
    next()
  ]
  controller.preCreate = [(req, res, next) ->
    req.body.userId = req.user.id
    req.Model = Todo
    next()
  ]
  controller.preUpdate = [(req, res, next) ->

    #try to find a todo that matches the ID in the uri and belongs to the user who is logged i
    Todo.find
      _id: req.params.id
      userId: req.user.id
    , (err, results) ->
      return next(err)  if err
      return res.send(401)  unless results
      #trying to update a todo that isn't yours?!?!?!
      req.Model = Todo
      next()

  ]
  controller.preDestroy = [(req, res, next) ->

    #try to find a todo that matches the ID in the uri and belongs to the user who is logged in
    Todo.find
      _id: req.params.id
      userId: req.user.id
    , (err, results) ->
      return next(err)  if err
      return res.send(401)  unless results
      #trying to update a todo that isn't yours?!?!?!
      req.Model = Todo
      next()

  ]
  controller
