module.exports = (app, acl, homeController, userController, todoController, apiController) ->
  
  # Home
  
  #User
  
  #
  #    Rather than go right to the API routes below, we need to do a few things first, like say what Users Todos
  #    to return and stamp the Todos they create with their ID.  Once we've dne these things (in the "pre" functions),
  #    we end up invoking the generic api methods.  Cool, right?
  #     
  
  #Generic restful api for all models - if previous routes are not matched, will fall back to these
  #See libs/params.js, which adds param middleware to load & set req.Model based on :model argument
  
  #
  #    default route if we haven't hit anything yet
  #    This will just return the index file and pass the url to our angular app.
  #    Angular will decide if it should display a 404 page.
  #     
  
  #
  #     Route Helpers
  #     
  
  #whenever a router parameter :model is matched, this is run
  
  #if the request is for a model that does not exist, 404
  
  #
  #    Make sure this person is logged in.
  #    If they aren't, return a 401.  This let's angular know to go to a login page.
  #     
  ensureAuthenticated = (req, res, next) ->
    return next()  if req.isAuthenticated()
    res.send 401

  app.get "/", homeController.index
  app.get /\/partials\/(.+)/, homeController.partial

  app.get "/user", userController.getCurrent
  app.post "/user/login", userController.authenticate
  app.post "/user/register", userController.create
  app.post "/user/logout", userController.kill

  app.get "/api/Todo", ensureAuthenticated, todoController.preSearch, apiController.search
  app.post "/api/Todo", ensureAuthenticated, todoController.preCreate, apiController.create
  app.put "/api/Todo/:id", ensureAuthenticated, todoController.preUpdate, apiController.update
  app.del "/api/Todo/:id", ensureAuthenticated, todoController.preDestroy, apiController.destroy

  app.get "/api/:model", ensureAuthenticated, apiController.search
  app.post "/api/:model", ensureAuthenticated, apiController.create
  app.get "/api/:model/:id", ensureAuthenticated, apiController.read
  app.put "/api/:model/:id", ensureAuthenticated, apiController.update
  app.del "/api/:model/:id", ensureAuthenticated, apiController.destroy

  app.get "*", homeController.index

  app.param "model", (req, res, next, model) ->
    console.log app
    Model = app.models[model]
    return res.send(404)  if Model is `undefined`
    req.Model = Model
    next()

