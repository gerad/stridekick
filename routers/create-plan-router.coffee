CalendarView = require('../views/calendar-view')
WorkoutFormView = require('../views/workout-form-view')
WorkoutAddView = require('../views/workout-add-view')
CreatePlanKeyboardView = require('../views/create-plan-keyboard-view')
Plan = require('../models/plan')
Day = require('../models/day')

class CreatePlanRouter extends Backbone.Router
  routes:
    ':day': 'show'

  # ## lifecycle

  initialize: ->
    today = (new Day).rfc3339String()

    @plan = new Plan(current_day: today)
    @calendarView = new CalendarView(el: $('#calendar'), model: @plan)
    @keyboardView = new CreatePlanKeyboardView(el: document, model: @plan)

    @plan.on 'change:current_day', @currentDayBinding, @
    @plan.on 'workouts:add workouts:remove', @workoutBinding, @

    @plan.loadWorkouts()
    @renderWorkout()

  # ## routes
  show: (day) ->
    @plan.set(current_day: day)
    @renderWorkout()

  # ## renders
  renderWorkout: ->
    @workoutView?.destroy()
    @workoutView = if (workout = @plan.currentWorkout())?
        new WorkoutFormView(el: $('form#workout'), model: workout)
      else
        new WorkoutAddView(el: $('#add-workout'), model: @plan)

  # ## bindings

  # `currentDayBinding` is called when the plan's `current_day` changes. It
  # triggers the `show` route for the new day.
  currentDayBinding: (plan, day, options) ->
    @navigate(day, trigger: true)

  # `workoutBinding` is called whenever a workout is added or removed. It
  # re-renders the workout for the current day if the changed workout happened
  # during the current day
  workoutBinding: (workout, workouts, options) ->
    if workout.get('day') is @plan.get('current_day')
      @renderWorkout()

module.exports = CreatePlanRouter
