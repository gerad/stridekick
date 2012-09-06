Day = require '../models/day'

class WorkoutAddView extends Backbone.View
  events:
    'click button.add': 'clickAdd'

  # ## lifecycle
  initialize: ->
    @plan = @model
    @render()

  render: ->
    day = new Day(@plan.get('current_day'))
    @$('h3').text(day.localeString())
    @$el.show()

  destroy: ->
    # unbind listeners on the current workout
    @model.off null, null, @

    # have the view stop listening to events
    @undelegateEvents()

    @$el.hide()

  # ## events

  # `clickAdd` adds a workout to the plan at the plan's `currentDay`
  clickAdd: ->
    @plan.addWorkout()

module.exports = WorkoutAddView
