Workout = require '../workout'

class Plan extends Backbone.Model
  initialize: ->
    @workouts = new Workout.Collection

  saveWorkout: (attributes) ->
    workout = @workouts.getOrAdd(attributes.day)
    workout.reset attributes

  workoutAtDay: (day) ->
    @workouts.get(day)

  addWorkout: ->
    @currentWorkout()

  currentWorkout: ->
    @workouts.getOrAdd(@currentDay())

  currentDay: ->
    @get('currentDay')

class Plan.Collection extends Backbone.Collection
  model: Plan

module.exports = Plan
