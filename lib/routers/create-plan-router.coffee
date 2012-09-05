CalendarView = require('../views/calendar-view')
WorkoutFormView = require('../views/workout-form-view')
WorkoutAddView = require('../views/workout-add-view')
Plan = require('../models/plan')
Day = require('../models/day')

class CreatePlanRouter extends Backbone.Router
  routes:
    ':day/add' : 'add'
    ':day'     : 'show'

  # ## lifecycle

  initialize: ->
    @plan = new Plan(currentDay: (new Day).rfc3339String())
    @calendarView = new CalendarView(el: $('table#calendar'), model: @plan)
    @formView = new WorkoutFormView(el: $('form#workout'), model: @plan)
    @addView = new WorkoutAddView(el: $('#add-workout'), model: @plan)

    @plan.on 'change:currentDay', (plan, day, options) =>
      @navigate day, trigger: true

    @plan.workouts.on 'add', =>
      @navigate "#{@plan.currentDay()}/add", trigger: true

  # ## routes
  show: (day) ->
    @plan.set(currentDay: day)
    @addView.show()
    @formView.hide()

  add: (day) ->
    @plan.set(currentDay: day)
    @addView.hide()
    @formView.show()

module.exports = CreatePlanRouter
