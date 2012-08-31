jade = require 'jade'

module.exports = (bundle) ->
  bundle.require('../lib/jade-runtime')
  bundle.register '.jade', (body) ->
    return """
      (function() {
        var jade = require('../lib/jade-runtime');
        module.exports = #{jade.compile(body, client: true, compileDebug: false)}
      })();"""
