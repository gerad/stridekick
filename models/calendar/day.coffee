class Day
  constructor: (date=new Date) ->
    @date = new Date(date.getFullYear(), date.getMonth(), date.getDate())

  # `clone` creates a copy of the day
  clone: -> new Day(@date)

  # `add` creates a new day with the specified # of `days` added
  add: (days) ->
    ret = @clone()
    date = ret.date
    date.setDate(date.getDate() + days)
    ret

  # `subtract` creates a new day with the specified # of `days` subtracted
  subtract: (days) ->
    @add(-days)

  # `next` returns the next day in the calendar
  next: -> @add(1)

  # `daysUntil` returns the number of days until the passed `other` day. It
  # expects `other` to be after the current day.
  daysUntil: (other) ->
    dayLength = 24 * 60 * 60 * 1000
    Math.round((other.date - @date) / dayLength)

  # `daysSince` returns the number of since until the passed `other` day. It
  # expects `other` to be before the current day.
  daysSince: (other) ->
    -@daysUntil(other)

  # `equals` returns true if the `other` day is the same day as this day.
  equals: (other) ->
    @daysUntil(other) is 0

  isToday: ->
    @equals(new Day)

  isTomorrow: ->
    @equals((new Day).add(1))

  isYesterday: ->
    @equals((new Day).subtract(1))

  # `dayOfWeek` returns the day # of the week (0-6) for this day
  dayOfWeek: ->
    @date.getDay()

  # `dayOfMonth` returns the day of the month (1-31) for this day
  dayOfMonth: ->
    @date.getDate()

  # `monthOfYear` returns the month # of the year (0-11) for this day
  monthOfYear: ->
    @date.getMonth()

  # `weekRange` takes returns an array of days for the this day's week
  # (defined as the Sunday through Saturday of this day's week).
  weekRange: ->
    weekday = @dayOfWeek()
    start = @subtract(weekday)
    end = @add(6 - weekday)
    Day.range(start, end)

  # `rfc3339String` returns the RFC 3339 (YYYY-MM-DD) string representation of
  # the date. This is useful for passing to html5 input[type=date] fields.
  rfc3339String: ->
    @date.toISOString().substr(0, 10)

# `range` returns an array of days between the `start` date and the `end` date
# (inclusive)
Day.range = (start, end) ->
  cur = start.subtract(1)
  until cur.equals(end)
    cur = cur.add(1)

# `ymd` returns a `new Day` with initialized to the given year, month and day
# NOTE: unlike the `Date` consturtor, the month here is 1 based, not 0 based
Day.ymd = (year, month, day) ->
  new Day(new Date(year, month - 1, day))

module.exports = Day
