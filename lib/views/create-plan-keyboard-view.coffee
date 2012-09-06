Day = require '../models/day'

class CreatePlanKeyboardView extends Backbone.View
  events:
    'keylisten': 'keylisten'
    'keylisten select': 'keylistenSelect'

  initialize: ->
    @plan = @model

  keylistenSelect: (e) ->
    e.stopImmediatePropagation()
    switch e.keyName
      when 'left', 'right', 'backspace', 'esc'
        @keylisten(e)

  keylisten: (e) ->
    switch e.keyName
      when 'left', 'right', 'up', 'down'
        @handleArrows(e)

      when 'esc'
        $(e.target).blur()

      when 'backspace'
        if (workout = @plan.currentWorkout())?
          e.preventDefault() # prevent back
          workout.remove()

      when 'return'
        e.preventDefault()
        @plan.addWorkout()

  handleArrows: (e) ->
    e.preventDefault() # prevent scrolling

    day = new Day(@plan.get('current_day'))
    newDay = switch e.keyName
      when 'left'
        day.previous()
      when 'right'
        day.next()
      when 'up'
        day.previousWeek()
      when 'down'
        day.nextWeek()

    @plan.set(current_day: newDay.rfc3339String())


module.exports = CreatePlanKeyboardView
