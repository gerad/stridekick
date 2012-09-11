Day = require '../models/day'
calendar = require './calendar-helper'
workout = require './workout-helper'

today = new Day()
goalDay = Day.ymd(2012, 12, 1) # northface
module.exports =
  calendar: calendar(goalDay, today)
  workout: workout(today)
