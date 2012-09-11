assert = require 'assert'
calendar = require '../helpers/calendar-helper'
Day = require '../models/day'

assert calendar, 'function exists'

goalDay = Day.ymd(2012, 12, 1)
startDay = Day.ymd(2012, 8, 23)

ret = calendar(goalDay, startDay)
assert ret, 'calendar returns an object'
assert ret.weekdays.length is 7, 'calendar has 7 weekdays'
assert ret.weeks.length is 15, 'object has 15 weeks'

firstWeek = ret.weeks[0]
assert firstWeek.num is 15, 'first week is #15'
assert not firstWeek.month?, 'first week has no month'
assert firstWeek.days.length is 7, 'first week has 7 days'

lastWeek = ret.weeks[14]
assert lastWeek.num is 1, 'last week is #1'
assert lastWeek.month is 'December', 'last week has "December" as a month'

firstDay = firstWeek.days[0]
assert firstDay.cssClass is false, 'first day has no css class'

lastDay = lastWeek.days[6]
assert lastDay.cssClass is 'goal', 'last day has "goal" as a css class'
assert lastDay.date is 1, 'last day date is 1'
