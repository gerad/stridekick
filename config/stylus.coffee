stylus = require('stylus')
nib = require('nib')
path = require('path')

module.exports = stylus.middleware
  src: path.join(__dirname, '..', 'public')
  dest: path.join(__dirname, '..', 'tmp', 'cache')
  compile: (str, path) ->
    stylus(str)
      .set('filename', path)
      .use(nib())
