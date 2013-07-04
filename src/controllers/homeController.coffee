module.exports = (app) ->
  index: [(req, res, next) ->
    res.render "index"
  ]

  partial: [(req, res, next) ->
    res.render "partials/" + req.params[0]
  ]
