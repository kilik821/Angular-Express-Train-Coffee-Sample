module.exports = (app, config) ->
  console.log "[express train application listening on %s]", config.port
  app.listen config.port
