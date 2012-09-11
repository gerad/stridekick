summarizeRepeat = require '../helpers/summarize-repeat'
Day = require '../models/day'

class WorkoutFormView extends Backbone.View
  events:
    'change input#day': 'changeDay'
    'change select#kind': 'changeKind'
    'change textarea#description': 'changeDescription'
    'change input#repeat': 'changeRepeat'
    'change select#repeat-kind': 'changeRepeatKind'
    'change input.repeat-on': 'changeRepeatOn'
    'change input[name=repeat_by]': 'changeRepeatBy'

  # ## lifecycle
  initialize: ->
    @workout = @model

    @workout.on 'change:kind', @kindBinding, @
    @workout.on 'change:description', @descriptionBinding, @
    @workout.on 'change:repeat', @repeatBinding, @
    @workout.on 'change:repeat_kind', @repeatKindBinding, @
    @workout.on 'change', @repeatSummaryBinding, @

    @render()

  render: ->
    @setupForm()
    @$el.show()
    if @workout.get('description')
      @$('#description').focus()
    else
      @$('#kind').focus()

  destroy: ->
    # unbind listeners on the current workout
    @model.off null, null, @

    # have the view stop listening to events
    @undelegateEvents()

    @$el.hide()

  # ## events

  changeDay: (e) ->
    @workout.save day: @$('input#day').val()

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
      @workout.save kind: kind
    else
      # cancel was hit, go back to the old kind
      @kindBinding()

  changeDescription: (e) ->
    @workout.save
      description: @$('textarea#description').val()
      description_edited: true

  changeRepeat: (e) ->
    isRepeating = $(e.target).is(':checked')
    @workout.save repeat: isRepeating

  changeRepeatKind: (e) ->
    @workout.save repeat_kind: $(e.target).val()

  changeRepeatBy: (e) ->
    repeat_by = @$('input[name=repeat_by]:checked').val()
    @workout.save repeat_by: repeat_by

  changeRepeatOn: (e) ->
    repeat_on = @$('input.repeat-on:checked').map ->
      @name.match(/^repeat-on-(\d)$/)[1]
    @workout.save repeat_on: repeat_on

  # ## bindings
  kindBinding: ->
    @$('select#kind').val(@workout.get('kind'))

  descriptionBinding: ->
    @$('#description').val(@workout.get('description'))

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
    for name, value of attributes
      @$("##{name}").val(value)

module.exports = WorkoutFormView
