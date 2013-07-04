module.exports = (app) ->
  log: (msg) ->
    (req, res, next) ->
      console.log msg
      next()

  apologize: (err, req, res, next) ->
    req.flash "Sorry, something went wrong"
    res.redirect "/"
    console.log "ERROR:", err
