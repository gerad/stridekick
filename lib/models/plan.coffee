Workout = require '../workout'

class Plan extends Backbone.Model
  initialize: ->
    @workouts = new Workout.Collection
    @workouts.on 'all', @proxyWorkoutsEvent, @
    @on 'workouts:change:day', @workoutDayBinding, @
    @on 'workouts:change:kind', @workoutKindBinding, @

  # ## helpers
  loadWorkouts: ->
    @workouts.fetch()

  addWorkout: ->
    @workouts.getOrCreate(@get('current_day'))

  currentWorkout: ->
    @workoutAtDay(@get('current_day'))

  workoutAtDay: (day) ->
    @workouts.get(day)

  # ## bindings

  # `workoutDayBinding` is called when the workout day changes. It changes the
  # `current_day` on this plan, taking care not to mark the workout as no
  # longer being edited.
  workoutDayBinding: (workout, day, options) ->
    @set { current_day: day }, { workout: workout }

  # `workoutKindBinding` is called when the workout `kind` changes. It infers
  # a description for the workout based on other workouts of the same kind.
  workoutKindBinding: (workout, kind, options) ->
    # don't do anything if the description has been manually edited
    unless workout.get('description_edited')
      if (closest = @workouts.closestOfSameKind(workout))?
        workout.save description: closest.get('description')

  # ## proxies

  # `proxyWorkoutsEvent` proxies events on the workouts collection through the
  # this instance. This allows greater encapsulation. That is, other objects
  # (views) can listen to `@plan.on 'workouts:add'` instead of having to reach
  # into the workouts association like `@plan.workouts.on 'add'`.
  proxyWorkoutsEvent: (args...) ->
    name = args.shift()
    @trigger "workouts:#{name}", args...

class Plan.Collection extends Backbone.Collection
  model: Plan

module.exports = Plan
