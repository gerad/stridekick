Day = require '../day'

class Workout extends Backbone.Model
  idAttribute: 'day'
  defaults:
    repeat: false
    kind: 'Recovery Run'
    repeat_kind: 'weekly'
    repeat_by: 'weekday'

  initialize: ->
    # default `repeat_on` to the day of the week of the current `day`
    if !@has('repeat_on')
      repeat_on = @date().getDay()
      @set repeat_on: "#{repeat_on}"

  # `date` returns a javascript `Date` corresponding to the `@day` string
  date: ->
    ymd = @get('day').split('-')
    new Date(+ymd[0], +ymd[1] - 1, +ymd[2])

  # `daysOfWeekToRepeatOn` returns an array of day of week integers (0-6)
  # corresponding to the `repeat_on` variable
  daysOfWeekToRepeatOn: ->
    for day in @get('repeat_on')
      +day

  pick: (attributes...) ->
    _.pick @attributes, attributes...

class Workout.Collection extends Backbone.Collection
  model: Workout
  localStorage: new Backbone.LocalStorage('workouts')

  # `daysBetween` returns the # of days between two workouts
  daysBetween = (a, b) ->
    aDay = new Day(a.get('day'))
    bDay = new Day(b.get('day'))
    Math.abs(aDay.daysUntil(bDay))

  # `closest` returns the closest (chronologically) workout of the same kind
  # as the given `workout`.
  closestOfSameKind: (workout) ->
    @reduce (closest, other) ->
      if workout isnt other and other.get('kind') is workout.get('kind')
        if not closest
          closest = other
        else if daysBetween(workout, other) < daysBetween(workout, closest)
          closest = other
      closest


  getOrCreate: (day) ->
    @get(day) ? @create(day: day)

module.exports = Workout
