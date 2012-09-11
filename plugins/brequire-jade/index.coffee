fs = require 'fs'
path = require 'path'
jade = require 'jade'

require.extensions['.jade'] = (module, filename) ->
  jadeRuntimePath = require.resolve('./jade-runtime')
  relativeJadeRuntimePath = path.relative(path.dirname(filename),
    jadeRuntimePath)

  body = fs.readFileSync(filename, 'utf8')
  compiled = """
    (function() {
      var jade = require('#{relativeJadeRuntimePath}');
      module.exports = #{jade.compile(body, client: true, compileDebug: false)}
    })();"""

  module._compile(compiled, filename)
