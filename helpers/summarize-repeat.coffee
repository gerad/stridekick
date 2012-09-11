days = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(/\s+/)
ordinals = 'first second third fourth fifth'.split(/\s+/)

# `summarizeRepeat` creates a string describing the repetition interval for
# the passed in argument list.
#
# It takes the following arguments.
#
# 1. `kind` - whether the repetition is "weekly", "biweekly" or "monthly"
# 2. `weekdays` - an array of days of the week (numbers 0-6) that indicate
#    what days of the week the repition occurs on
# 3. `date` - a Date object corresponding to the date of the event to be
#             repeated
# 4. `onDate` - `true` if the monthly repetition occurs on a specific day of
#    the month, otherwise, the monthly repetition is determined by the day of
#    the week of the week in the month of the `date`
summarizeRepeat = (kind, weekdays, date, onDate) ->
  if kind is 'monthly'
    if onDate
      onMonthDate(date)
    else
      onMonthWeekday(date)
  else # weekly or biweekly
    if weekdays.length is 0
      'never'
    else
      interval = 'every'
      interval += ' other' if kind is 'biweekly'
      "#{interval} #{dayString(weekdays)}"

ordinalize = (num) ->
  suffix = if 10 < num < 14
      'th'
    else
      switch num % 10
        when 1 then 'st'
        when 2 then 'nd'
        when 3 then 'rd'
        else 'th'
  num + suffix

toSentence = (words) ->
  last = words.pop()
  switch words.length
    when 0
      last
    when 1
      "#{words[0]} and #{last}"
    else
      "#{words.join(', ')}, and #{last}"

# `onMonthDate` returns a string like "on the 3rd of every month"
onMonthDate = (date, onDate) ->
  day = date.getDate()
  if day
    "on the #{ordinalize(date.getDate())} of every month"

# `onMonthWeekday` returns a string like "on the first Wednesday of every month"
onMonthWeekday = (date) ->
  weeknum = weeknumString(date)
  weekday = days[date.getDay()]
  "on the #{weeknum} #{weekday} of every month"

# `dayString` turns an array of `weekdays` into a string like: "Wednesday" or
# "Monday, Tuesday, and Thursday"
dayString = (weekdays) ->
  if weekdays.length is 7
    'day' # every day
  else if weekdays.join('') is '12345'
    'weekday'
  else
    # make sunday display as the last day, not the first
    if weekdays[0] is 0
      weekdays.push(weekdays.shift())

    words = for weekday in weekdays
      days[weekday]

    toSentence(words)

# `nextweek` returns a copy of the passed in `date` with one week added
nextweek = (date) ->
  dupe = new Date(date.getTime())
  dupe.setDate(dupe.getDate() + 7)
  dupe

# `weeknumString` returns the week of the month of the current date, in
# a nicely formatted string.
weeknumString = (date) ->
  last = nextweek(date).getMonth() isnt date.getMonth()
  if last
    'last'
  else
    ordinals[0 | date.getDate() / 7]


module.exports = summarizeRepeat
