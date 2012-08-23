Day = require '../models/calendar/day'
calendar = require './calendar-helper'
{ extend } = require '../lib/utilities'

today = new Day()
goalDay = Day.ymd(2012, 12, 1) # northface
extend module.exports, calendar(goalDay, today), today: today
