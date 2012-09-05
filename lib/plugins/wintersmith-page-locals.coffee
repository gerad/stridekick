path = require 'path'
{ extend, isString, withEmptyRequireCache } = require '../utilities'

module.exports = (wintersmith, callback) ->
  JsonPage = wintersmith.defaultPlugins.JsonPage

  class PageLocalsPlugin extends JsonPage
    render: (locals, contents, templates, callback) ->
      ctx = extend {}, locals, @locals()
      super ctx, contents, templates, callback

    # `locals` returns the locals for this page, as determined from the page
    # `locals` metadata. If it is a string, then it assumes the string is a
    # path to a javascript file, and it determines the locals by `require`ing
    # that javascript file. Hence allowing more dynamic locals.
    locals: ->
      locals = @_metadata.locals ? {}

      if isString(locals)
        withEmptyRequireCache ->
          locals = require path.join @_base, locals

      locals

  PageLocalsPlugin.fromFile = (filename, base, callback) ->
    JsonPage.fromFile.call @, filename, base, (error, page) ->
      return callback(error) if error?

      page._base = base
      callback null, page

  wintersmith.registerContentPlugin 'pages', '**/*.json', PageLocalsPlugin
  callback()
