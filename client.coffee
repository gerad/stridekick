$ = require('./utilities/jquery')
_ = require('./utilities/underscore')
Backbone = require('./utilities/backbone')

CreatePlanRouter = require('./routers/create-plan-router')

class Client
  constructor: ->
    new CreatePlanRouter

  start: ->
    Backbone.history.start()

module.exports = new Client
