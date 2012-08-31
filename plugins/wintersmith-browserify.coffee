path = require 'path'
browserify = require 'browserify'
wintersmith = require 'wintersmith'
browserifyJade = require './browserify-jade'

class BrowserifyPlugin extends wintersmith.ContentPlugin
  constructor: (@_filename, @_base) ->

  getFilename: -> @_filename # .replace(/\.coffee$/, '.js')

  render: (locals, contents, templates, callback) ->
    bundle = browserify cache: false
    bundle.use(browserifyJade)
    try
      bundle.addEntry(path.join(@_base, @_filename))
    catch e
      return callback e

    callback null, new Buffer(bundle.bundle())

BrowserifyPlugin.fromFile = (filename, base, callback) ->
  plugin = new BrowserifyPlugin(filename, base)
  callback null, plugin

module.exports = (wintersmith, callback) ->
  wintersmith.registerContentPlugin 'scripts', '**/*.js', BrowserifyPlugin
  callback()
