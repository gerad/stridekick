summarizeRepeat = require './lib/summarize-repeat'
Day = require '../../../models/calendar/day'

class WorkoutFormView extends Backbone.View
  events:
    'change input#day': 'changeDay'
    'change input#repeat': 'changeRepeat'
    'change select#repeat-kind': 'changeRepeatKind'
    'change input.repeat-on': 'changeRepeatOn'
    'change input[name=repeat_by]': 'changeRepeatBy'
    'change select#kind': 'changeKind'

  # ## lifecycle
  initialize: ->
    @plan = @model
    @hide() # the form is hidden by default

  # `show` is called when the workout form should be shown. It displays the
  # form with the current workout for the day.
  show: ->
    @delegateEvents()
    @setWorkout @plan.currentWorkout()
    @setupForm()
    @$el.show()

  # `hide` is called when the workout form should be hidden. It saves the
  # current workout in the form before hiding itself.
  hide: ->
    @undelegateEvents()
    if @workout?
      @plan.saveWorkout(@workoutize(@serialize()))
      @clearWorkout()
    @$el.hide()


  # ## events

  changeDay: (e) ->
    @workout.set day: @$('input#day').val()

  changeRepeat: (e) ->
    isRepeating = $(e.target).is(':checked')
    @workout.set repeat: isRepeating

  changeRepeatKind: (e) ->
    @workout.set repeat_kind: $(e.target).val()

  changeRepeatBy: (e) ->
    repeat_by = @$('input[name=repeat_by]:checked').val()
    @workout.set repeat_by: repeat_by

  changeRepeatOn: (e) ->
    repeat_on = @$('input.repeat-on:checked').map ->
      @name.match(/^repeat-on-(\d)$/)[1]
    @workout.set repeat_on: repeat_on

  # `changeKind` changes the workout kind when the select#kind changes. If the
  # select#kind is changed to "Other..." then a javascript prompt asks for the
  # new kind, and that option is added to the DOM
  changeKind: (e) ->
    kind = $(e.target).val()
    if kind is 'add'
      # TODO stop using javascript prompts to add new kinds
      # TODO stop saving state (the added `kind`) in the DOM
      if (toAdd = prompt("What kind of run do you want to add?"))?
        @$('select#kind .separator').before($('<option>', text: toAdd))
        kind = toAdd
      else
        kind = null

    if kind?
      @workout.set kind: kind
    else
      # cancel was hit, go back to the old kind
      @kindBinding()


  # ## bindings
  kindBinding: ->
    @$('select#kind').val(@workout.get('kind'))

  # `repeatBinding` checks the repeat checkbox if the workout is repeating,
  # and toggles the visibility of the appopriate elements
  repeatBinding: ->
    isRepeating = !!@workout.get('repeat')

    # check the repeat checkbox
    @$('#repeat').prop('checked', isRepeating)

    # show the repeat options
    @$('p.repeat-options').toggle(isRepeating)

  # `repeatKindBinding` changes the repeat option visibilty based on the
  # repeat kind.
  repeatKindBinding: ->
    kind = @workout.get('repeat_kind')
    isMonthly = kind.toLowerCase() is 'monthly'

    # set the value of the repeat option
    $('p.repeat-options select').val(kind)

    # if it's not a monthly repeat, show the weekly repeat options
    $('p.repeat-options .weekly').toggle(!isMonthly)

    # if it's a monthly repeat, show the monthly repeat options
    $('p.repeat-options .monthly').toggle(isMonthly)

  # `repeatOnBinding` checks the correct days of the week for the weekly and
  # biweekly repetition option.
  repeatOnBinding: ->
    for weekday in @workout.get('repeat_on')
      @$("#repeat-on-#{weekday}").prop('checked', true)

  # `repeatByBinding` checks the correct radio button for the monthly
  # repetition option
  repeatByBinding: ->
    repeat_by = @workout.get('repeat_by')
    @$("input[name=repeat_by][value=#{repeat_by}]").prop('checked', true)

  # `repeatSummaryBinding` populates the repeat checkbox label whenever the
  # workout changes
  repeatSummaryBinding: ->
    summary = if @workout.get('repeat')
        "Repeat #{@repeatSummary()}"
      else
        "Repeat&hellip;"
    @$('p.repeat span.summary').html(summary)

  # ## helpers

  # `repeatSummary` calculates the repeat summary for the current workout.
  # It uses an external `summarizeRepeat` method, which is defined and tested
  # independently.
  repeatSummary: ->
    summarizeRepeat(@workout.get('repeat_kind'),
      @workout.daysOfWeekToRepeatOn(),
      @workout.date(),
      @workout.get('repeat_by') is 'date')

  # `setupForm` sets the views `@workout` to the `@plan.currentWorkout()` and
  # initializes the form based on the values of the `@workout`
  setupForm: ->
    # reset the form to its default values
    @$el.reset()
    @$('input#day').focus()

    # update the form to match the new workout
    attributes = @workout.toJSON()

    # handle the custom attribute bindings
    @repeatBinding()
    delete attributes.repeat

    @repeatKindBinding()
    delete attributes.repeat_kind

    @repeatOnBinding()
    delete attributes.repeat_on

    @repeatByBinding()
    delete attributes.repeat_by

    @repeatSummaryBinding()
    delete attributes.repeat_summary

    # handle the remaining attributes in bulk
    @deserialize attributes

  # `setupWorkout` sets up the view to work with a new workout. It:
  #
  # 1. unbinds all the listeners on the existing `@workout`
  # 2. stores the passed `workout` as the new `@workout`
  # 3. adds listeners on the new workout
  setWorkout: (workout) ->
    @clearWorkout() # clear the current workout if there is one

    # save the new workout
    @workout = workout

    # add new events
    @workout.on 'change:kind', @kindBinding, @
    @workout.on 'change:repeat', @repeatBinding, @
    @workout.on 'change:repeat_kind', @repeatKindBinding, @
    @workout.on 'change', @repeatSummaryBinding, @

    @deserialize @workout.toJSON()

  # `clearWorkout` removes event listeners from `@workout@ and sets it to null
  clearWorkout: ->
    if @workout?
      # unbind listeners on the current workout
      @workout.off null, null, @
      @workout = null

  # `workoutize` takes the object from the serialized form and converts it
  # into the format that the model expects
  workoutize: (object) ->
    # change the `repeat_on` checkboxes into the single string the model
    # expects
    repeat_on = []
    for k, v of object
      if (match = k.match(/^repeat-on-(\d)$/))?
        repeat_on.push match[1]
        delete object[k]
    if repeat_on.length > 0
      object.repeat_on = repeat_on.join('')

    object

  # `serialize` creates an object out of the form (so it can then be passed to
  # the model's `set` method to set all the attributes for the workout)
  serialize: ->
    ret = {}
    for { name, value } in @$el.serializeArray()
      ret[name] = value
    ret

  # `deserialize` sets all the field values based on the passed in `object`
  deserialize: (object) ->
    for name, value of object
      @$("##{name}").val(value)

module.exports = WorkoutFormView