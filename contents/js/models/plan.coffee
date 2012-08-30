Workout = require '../workout'

class Plan extends Backbone.Model
  initialize: ->
    @workouts = new Workout.Collection

  saveWorkout: (attributes) ->
    workout = @workouts.getOrAdd(attributes.day)
    workout.reset attributes

  currentWorkout: ->
    @workouts.getOrAdd(@currentDay())

  currentDay: ->
    @get('currentDay')

class Plan.Collection extends Backbone.Collection
  model: Plan

module.exports = Plan
