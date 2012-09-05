path = require 'path'
jade = require 'jade'

module.exports = (bundle) ->
  relativeDirPath = path.relative(process.cwd(), __dirname)
  jadeRuntimePath = path.join('..', relativeDirPath, 'jade-runtime')

  bundle.require(jadeRuntimePath)
  bundle.register '.jade', (body) ->
    return """
      (function() {
        var jade = require('#{jadeRuntimePath}');
        module.exports = #{jade.compile(body, client: true, compileDebug: false)}
      })();"""
