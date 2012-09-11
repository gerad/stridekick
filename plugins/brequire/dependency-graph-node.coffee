fs = require('fs')
path = require('path')
detective = require('detective')

class DependencyGraphNode
  constructor: (@fullPath) ->
    @body = @load(@fullPath)
    @requires = detective(@body)

  # `load` loads the file body from the file system. It uses the compilers
  # associated with `require.extension` to do any compilation (if needed) to
  # the loaded file to transform it into javascript.
  load: (fullPath) ->
    ext = path.extname(fullPath)
    if (compiler = require.extensions[ext])?
      # if it needs to be compiled, compile it
      @compile(fullPath, compiler)
    else
      # otherwise, just load it
      fs.readFileSync(fullPath)

  # `compile` monkey patches the built in compiler to compile the file
  compile: (fullPath, compiler) ->
    # fake out the `module` object that the `compiler` expects
    module_ =
      exports: {}
      _compile: (content, filename) -> @exports = content

    # perform the compilation
    compiler(module_, fullPath)

    # return the result
    module_.exports

  toJSON: ->
    name: @name
    children: @children

module.exports = DependencyGraphNode
