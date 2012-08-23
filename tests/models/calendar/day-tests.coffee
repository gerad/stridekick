assert = require 'assert'
Day = require '../../../models/calendar/day'

assert Day, 'Day is defined'

# initialization

today = new Day
assert today, 'can be initialized'

# add

tomorrow = today.add(1)
assert tomorrow, 'can add a day'

# subtract

assert tomorrow.subtract(1).equals(today),
  'subtracting a day from tomorrow is today'

# daysUntil

assert today.daysUntil(tomorrow) is 1, 'one day until tomorrow'

# daysSince

assert tomorrow.daysSince(today) is 1, 'one day since today'

# isToday

assert today.isToday(), 'initialized to today by default'

# isTomorrow

assert tomorrow.isTomorrow(), 'adding a day makes it tomorrow'

# dayOfWeek

assert today.dayOfWeek() is (new Date).getDay(),
  'returns the correct day of the week'

# dayOfMonth

assert today.dayOfMonth() is (new Date).getDate(),
  'returns the correct day of the month'

# monthOfYear

assert today.monthOfYear() is (new Date).getMonth(),
  'returns the correct month of the year'

# weekRange

weekRange = today.weekRange()
assert weekRange, 'can create a week range'
assert weekRange.length is 7, 'range has 7 days'
assert weekRange[0].dayOfWeek() is 0, 'range starts on a sunday'
assert weekRange[6].dayOfWeek() is 6, 'range ends on a saturday'

# rfc3339String
day = Day.ymd(2012, 1, 1)
assert day.rfc3339String() is '2012-01-01', 'rfc3339String is correct'

# Day.range

range = Day.range(today, tomorrow)
assert range, 'can create a range'
assert range.length is 2, 'range has the correct number of items'
assert range[0].equals(today), 'first item in the range is correct'
assert range[1].equals(tomorrow), 'last item in the range is correct'

# Day.ymd
ymd = Day.ymd(2012, 8, 23)
assert ymd, 'can initialize a date with ymd'
assert ymd.monthOfYear() is 7, 'gets the correct month'
