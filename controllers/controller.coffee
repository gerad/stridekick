class Controller
  constructor: (@req, @res) ->

  render: (template, locals={}) ->
    locals.page ?= template
    locals.brequire ?= @req.brequire
    @res.render template, locals

module.exports = Controller
