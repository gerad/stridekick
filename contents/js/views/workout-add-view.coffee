Day = require '../../../models/calendar/day'

class WorkoutAddView extends Backbone.View
  events:
    'click button.add': 'clickAdd'

  # ## lifecycle
  initialize: ->
    @plan = @model
    @plan.on 'change:currentDay', @currentDayBinding, @

  hide: ->
    @$el.hide()

  show: ->
    @$el.show()

  # ## events

  # `clickAdd` adds a workout to the plan at the plan's `currentDay`
  clickAdd: ->
    @plan.addWorkout()

  # ## bindings
  currentDayBinding: ->
    day = new Day(@plan.currentDay())
    @$('h3').text(day.localeString())

module.exports = WorkoutAddView
