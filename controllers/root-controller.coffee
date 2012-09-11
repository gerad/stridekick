Controller = require('./controller')

class RootController extends Controller
  index: ->
    locals = require('../helpers/create-plan-helper')
    @render('index', locals)

module.exports = RootController
