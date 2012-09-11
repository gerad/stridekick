routes = (app) ->
  # index
  addController(app, 'root')

actions = {
  'index'   : 'GET /'
  'new'     : 'GET /new'
  'create'  : 'POST /'
  'show'    : 'GET /:id'
  'edit'    : 'GET /edit'
  'update'  : 'PUT /:id'
  'destroy' : 'DEL /:id' }

# `addController` tells express to load routes for a given controller class.
#
# The controller class is loaded from the file at
# `../controllers/#{controllerName}-controller`
#
# If the class prototype includes a method for one of the above actions, then
# this method will:
#
# 1. creates a route in express based on the controller name and the action
# 2. when the route is hit, instantiates a new instance of the controller,
#    with `req`, `res`, and `next` as parameters passed to the constructor
# 3. calls the correct action on the instance
#
addController = (app, controllerName) ->
  controllerClass = require("../controllers/#{controllerName}-controller")

  # loop through all the actions that the controller supports
  for action, route of actions when controllerClass.prototype[action]?
    [method, path] = route.split(/\s+/)

    # prepend the controller name to the path (unless it's the root controller)
    if controllerName isnt 'root'
      path = "/#{controllerName}" + path

    do (action) ->
      app[method.toLowerCase()] path, (req, res, next) ->
        controller = new controllerClass(req, res, next)
        controller[action]()


module.exports = routes
