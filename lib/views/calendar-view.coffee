dayTemplate = require '../templates/calendar-widget-day'
Day = require '../models/day'

class CalendarView extends Backbone.View
  events:
    'click .day': 'clickDay'

  # ## lifecycle
  initialize: ->
    @plan = @model
    @plan.on 'change:current_day', @currentDayBinding, @
    @plan.on 'workouts:add workouts:remove workouts:change', @workoutBinding, @

    $(document).keylisten @keylisten

  # ## events
  clickDay: (e) ->
    e.preventDefault()
    day = $(e.target).closest('.day').data('day')
    @plan.set current_day: day

  # ## bindings
  currentDayBinding: (plan, day, options) ->
    @$('.day.current').removeClass('current')
    @divForDay(day).addClass('current')

  # `workoutBinding` re-renders the workout in the calendar if it changes
  workoutBinding: (workout, options) ->
    day = workout.get('day')
    # update the calendar day for the workout
    @renderDay(day)

    previousDay = workout.previous('day')
    if previousDay? and day isnt previousDay
      @renderDay(previousDay)

  keylisten: (e) =>
    switch e.keyName
      when 'left', 'right', 'up', 'down'
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

      when 'backspace'
        if (workout = @plan.currentWorkout())?
          e.preventDefault() # prevent back
          workout.remove()

  # ## helpers
  divForDay: (day) ->
    @$(".day[data-day='#{day}']")

  # `renderDay` renders a given workout by finding the .day for the workout
  # and updating its contents
  renderDay: (dayString) ->
    day = Day.ymd dayString.split('-')...

    locals = date: day.dayOfMonth()
    if (workout = @plan.workoutAtDay(dayString))?
      locals.workout = workout.pick('kind', 'description')

    html = dayTemplate day: locals
    @divForDay(dayString).find('.box').html html

module.exports = CalendarView
