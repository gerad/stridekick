module.exports =
  build: (callback) ->
    ret = {}
    callback(ret)
    ret

  extend: (obj, others...) ->
    for other in others
      for own name, val of other
        obj[name] = val
    obj

  isString: (obj) ->
    Object::toString.call(obj) is '[object String]'

  # `withEmptyRequireCache` clears the require cache so that `require`d
  # modules are loaded afresh.
  #
  # NOTE: this is dangerous and can lead to infinite loops, so be careful
  withEmptyRequireCache: (callback) ->
    try
      oldCache = require.cache
      require.cache = {}
      callback()
    finally
      require.cache = oldCache
