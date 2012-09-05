dayTemplate = require '../../../templates/calendar-widget-day'
Day = require '../../../models/calendar/day'

class CalendarView extends Backbone.View
  events:
    'click td': 'clickTd'

  # ## lifecycle
  initialize: ->
    @plan = @model
    @plan.on 'change:currentDay', @currentDayBinding, @

    # TODO remove the nested dependency?
    @plan.workouts.on 'add remove change', @workoutBinding, @

    $(document).keylisten @keylisten


  # ## events
  clickTd: (e) ->
    e.preventDefault()
    day = $(e.target).closest('td').data('day')
    @plan.set currentDay: day

  # ## bindings
  currentDayBinding: (plan, day, options) ->
    @$('td.current').removeClass('current')
    @tdForDay(day).addClass('current')

  # `workoutBinding` re-renders the workout in the calendar if it changes
  workoutBinding: (workout, options) ->
    day = workout.get('day')
    # update the calendar day for the workout
    @renderDay(day)

  keylisten: (e) =>
    switch e.keyName
      when 'left', 'right', 'up', 'down'
        e.preventDefault() # prevent scrolling

        day = new Day(@plan.currentDay())
        newDay = switch e.keyName
          when 'left'
            day.previous()
          when 'right'
            day.next()
          when 'up'
            day.previousWeek()
          when 'down'
            day.nextWeek()

        @plan.set(currentDay: newDay.rfc3339String())

      when 'backspace'
        if (workout = @plan.currentWorkout())?
          e.preventDefault() # prevent back
          workout.remove()

  # ## helpers
  tdForDay: (day) ->
    @$("td[data-day='#{day}']")

  # `renderDay` renders a given workout by finding the td for the workout
  # and updating its contents
  renderDay: (dayString) ->
    day = Day.ymd dayString.split('-')...

    locals = date: day.dayOfMonth()
    if (workout = @plan.workoutAtDay(dayString))?
      locals.workout = workout.pick('kind', 'description')

    html = dayTemplate day: locals
    @tdForDay(dayString).html html

module.exports = CalendarView
