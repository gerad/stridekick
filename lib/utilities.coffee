module.exports =
  build: (fn) ->
    ret = {}
    fn ret
    ret

  extend: (obj, others...) ->
    for other in others
      for own name, val of other
        obj[name] = val
    obj

  isString: (obj) ->
    Object::toString.call(obj) is '[object String]'
