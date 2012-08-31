dayTemplate = require '../../../templates/calendar-widget-day'

class CalendarView extends Backbone.View
  events:
    'click td': 'clickTd'

  # ## lifecycle
  initialize: ->
    @plan = @model
    @plan.on 'change:currentDay', @changeCurrentDay, @
    @plan.workouts.on 'change', @changeWorkout, @

  # ## events
  clickTd: (e) ->
    e.preventDefault()
    day = $(e.target).closest('td').data('day')
    @plan.set currentDay: day

  # ## bindings
  changeCurrentDay: (plan, day, options) ->
    @$('td.current').removeClass('current')
    @tdForDay(day).addClass('current')

  # `changeWorkout` re-renders the workout in the calendar if it changes
  changeWorkout: (workout, options) ->
    html = dayTemplate day:
      date: workout.date().getDate()
      workout: workout.pick('kind', 'description')

    @tdForDay(workout.get('day')).html html

  # ## helpers
  tdForDay: (day) ->
    @$("td[data-day='#{day}']")

module.exports = CalendarView