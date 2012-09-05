Day = require './day'

class Week
  # `constructor` creates a week around the passed `currentDay`
  constructor: (currentDay=new Day) ->
    @days = currentDay.weekRange()

  # `monthOfYear` returns the month # of the year for the **last day** of this
  # week (last day was more useful for the calendar view)
  monthOfYear: ->
    @days[6].monthOfYear()

  equals: (other) ->
    @days[0].equals(other.days[0])

  # `next` returns the next week in the calendar
  next: ->
    new Week(@days[0].add(7))

  # `previous` returns the previous week in the calendar
  previous: ->
    new Week(@days[0].subtract(7))

Week.range = (start, end) ->
  cur = start.previous()
  until cur.equals(end)
    cur = cur.next()

module.exports = Week