express = require('express')
path = require('path')

app = express()

# # setup
app.configure ->

  # ## setup logging

  app.use(express.logger())

  # ## setup templates

  # set the default extension for templates to jade
  app.set('view engine', 'jade')
  # tell express to look for views in ../templates
  app.set('views', path.join(__dirname, '..', 'templates'))

  # ## setup stylesheets

  stylus = require('./stylus')
  app.use(stylus)

  # ## setup javascripts

  brequire = require('../plugins/brequire')
  require '../plugins/brequire-jade' # enable `require` of .jade files
  app.use(brequire('../assets/javascripts', __filename))

  # ## setup static middleware

  # first, look for static files in the assets directory
  app.use(express.static(path.join(__dirname, '..', 'assets')))

  # then, look for the files in the static cache
  app.use(express.static(path.join(__dirname, '..', 'tmp', 'cache')))

# setup routes
routes = require('./routes')
routes(app);

module.exports = app;
