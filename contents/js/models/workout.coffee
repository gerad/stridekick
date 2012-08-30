Workout = require '../workout'

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

  # `daysOfWeekToRepeatOn` returns an array of day of week numbers (0-6)
  # corresponding to the `repeat_on` variable
  daysOfWeekToRepeatOn: ->
    for day in @get('repeat_on')
      +day

  reset: (attributes) ->
    @clear silent: true
    @set attributes

class Workout.Collection extends Backbone.Collection
  model: Workout
  getOrAdd: (day) ->
    unless (ret = @get(day))?
      ret = new @model(day: day)
      @add(ret)
    ret

module.exports = Workout
