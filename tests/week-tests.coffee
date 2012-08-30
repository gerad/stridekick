assert = require 'assert'
Week = require '../models/calendar/week'
Day = require '../models/calendar/day'

assert Week, 'Week is defined'

# initialization

thisWeek = new Week
assert thisWeek, 'can be initialized'

nextWeek = new Week((new Day).add(7))
assert nextWeek, 'can be initialized around a specified day'

assert thisWeek.days[0].add(7).equals(nextWeek.days[0]),
  'specifying the day picks the week properly'

# days
weekdays = thisWeek.days
assert weekdays.length is 7, 'has 7 days'
assert weekdays[0].dayOfWeek() is 0, 'starts on sunday'
assert weekdays[6].dayOfWeek() is 6, 'ends on saturday'

# monthOfYear

assert thisWeek.monthOfYear() is weekdays[6].monthOfYear(),
  'returns the month of the last day of the week'

# Week.range
range = Week.range(thisWeek, nextWeek)
assert range, 'can create a range'
assert range.length is 2, 'range has the proper length'
assert range[0].equals(thisWeek), 'range starts with the correct week'
assert range[1].equals(nextWeek), 'range ends with the correct week'
