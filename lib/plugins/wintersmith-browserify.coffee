path = require 'path'
fs = require 'fs'
browserify = require 'browserify'

module.exports = (wintersmith, callback) ->
  class BrowserifyPlugin extends wintersmith.ContentPlugin
    constructor: (@_filename, @_base, @_plugins=[]) ->

    getFilename: -> @_filename.replace(/\.coffee$/, '.js')

    render: (locals, contents, templates, callback) ->
      bundle = browserify cache: false
      try
        for plugin in @_plugins
          bundle.use(require(path.resolve(plugin)))

        bundle.addEntry(path.join(@_base, @_filename))
      catch e
        return callback e

      callback null, new Buffer(bundle.bundle())

  BrowserifyPlugin.fromFile = (filename, base, callback) ->
    fs.readFile path.resolve('config.json'), 'utf8', (error, data) ->
      return callback error if error

      json = JSON.parse(data)
      browserifyPlugins = json.browserifyPlugins ? []

      plugin = new BrowserifyPlugin(filename, base, browserifyPlugins)
      callback null, plugin

  wintersmith.registerContentPlugin 'scripts', '**/*.coffee', BrowserifyPlugin
  callback()
