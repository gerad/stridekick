$ = jQuery
$.fn.reset = ->
  $(@).each -> @reset()
