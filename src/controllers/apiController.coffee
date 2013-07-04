module.exports = (app) ->
  controller = {}

  #
  #     Generic CRUD functions for any model
  #     
  #         route functions get 3 args - the request object, the response object, and next - a callback to move on
  #         to the next middleware.
  #         req.query = json object with query string arguments
  #         req.params = json object with values of routing params such as :model or :id
  #         req.body = json request body from post / put requests
  #         
  controller.search = [(req, res, next) ->
    console.log "starting api.search"
    query = req.query

    #req.Model is a value I set in libs/params.js
    req.Model.find query, (err, docs) ->
      return next(err)  if err
      res.json docs

  ]
  controller.create = [(req, res, next) ->
    console.log req.body
    model = new req.Model(req.body)
    model.save (err, doc) ->
      return next(err)  if err
      res.json doc

  ]
  controller.read = [(req, res, next) ->
    id = req.params.id
    req.Model.findById id, (err, doc) ->
      return next(err)  if err
      return res.send(404)  if doc is null
      res.json doc

  ]
  controller.update = [(req, res, next) ->
    id = req.params.id
    delete req.body._id
    #removing the _id from the model to prevent mongo from thinking we are trying to change its type

    req.Model.findByIdAndUpdate id, req.body, (err, doc) ->
      return next(err)  if err
      return res.send(404)  if doc is null
      res.json doc

  ]
  controller.destroy = [(req, res, next) ->
    id = req.params.id
    req.Model.findByIdAndRemove id, (err, doc) ->
      return next(err)  if err
      return res.send(404)  if doc is null
      res.send 204

  ]
  controller
