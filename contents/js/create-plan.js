var CalendarView = require('./views/calendar-view');
var WorkoutFormView = require('./views/workout-form-view');
var WorkoutAddView = require('./views/workout-add-view');
var Plan = require('./models/plan');
var Day = require('../../models/calendar/day');

var plan = new Plan({ currentDay: (new Day).rfc3339String() });
var calendarView = new CalendarView({ el: $('table#calendar'), model: plan });
var formView = new WorkoutFormView({ el: $('form#workout'), model: plan });
var addView = new WorkoutAddView({ el: $('#add-workout'), model: plan });

plan.workouts.on('add', function() {
  addView.hide();
  formView.show();
});

plan.on('change:currentDay', function() {
  addView.show();
  formView.hide();
});