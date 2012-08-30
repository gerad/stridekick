var CalendarView = require('./views/calendar-view');
var WorkoutFormView = require('./views/workout-form-view');
var Plan = require('./models/plan');

var plan = new Plan({ currentDay: '2012-08-29' });
var calendarView = new CalendarView({ el: $('table#calendar'), model: plan });
var formView = new WorkoutFormView({ el: $('form#workout'), model: plan });
