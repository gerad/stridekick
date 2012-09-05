CalendarView = require('../views/calendar-view')
WorkoutFormView = require('../views/workout-form-view')
WorkoutAddView = require('../views/workout-add-view')
Plan = require('../models/plan')
Day = require('../models/day')

plan = new Plan(currentDay: (new Day).rfc3339String())
calendarView = new CalendarView(el: $('table#calendar'), model: plan)
formView = new WorkoutFormView(el: $('form#workout'), model: plan)
addView = new WorkoutAddView(el: $('#add-workout'), model: plan)

plan.workouts.on 'add', ->
  addView.hide()
  formView.show()

plan.on 'change:currentDay', ->
  addView.show()
  formView.hide()
