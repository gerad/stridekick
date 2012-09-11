Day = require '../models/day'
calendar = require './calendar-helper'
{ extend } = require '../utilities'

today = new Day()
goalDay = Day.ymd(2012, 12, 1) # northface
extend module.exports, calendar(goalDay, today), today: today
