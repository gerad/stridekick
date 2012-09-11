workout = (day) ->
  localeDay: day.localeString()
  rfc3339Day: day.rfc3339String()
  weekdays: require('./weekdays')

module.exports = workout
