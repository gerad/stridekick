Week = require '../models/calendar/week'
Day = require '../models/calendar/day'
{ build } = require '../lib/utilities'

weekdays = "Su Mo Tu We Th Fr Sa".split(/\s+/)
months = """January February March April May June July August September
  October November December""".split(/\s+/)

# `calendar` returns the object needed to render the calendar template
calendar = (goalDay, startDay=new Day) ->
  startWeek = new Week(startDay)
  endWeek = new Week(goalDay)

  build (ret) ->
    # append the list of weekdays for the view
    ret.weekdays = weekdays

    # add the array of weeks
    currentMonth = startWeek.monthOfYear()
    ret.weeks = for week, num in Week.range(startWeek, endWeek)
      build (ret) ->
        # add the week number
        ret.num = num + 1

        # add month for the week, if the month has changed
        if week.monthOfYear() isnt currentMonth
          currentMonth = week.monthOfYear()
          ret.month = months[currentMonth]

        # add the days of the week
        ret.days = for day in week.days
          build (ret) ->
            ret.cssClass = if day.equals(goalDay)
                'goal'
              else if day.equals(startDay)
                'current'
              else
                false
            ret.date = day.dayOfMonth()

module.exports = calendar
