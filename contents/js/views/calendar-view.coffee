class CalendarView extends Backbone.View
  events:
    'click td': 'clickTd'

  # ## lifecycle
  initialize: ->
    @plan = @model
    @plan.on 'change:currentDay', @changeCurrentDay, @

  # ## events
  clickTd: (e) ->
    e.preventDefault()
    day = $(e.target).closest('td').data('day')
    @plan.set currentDay: day

  # ## bindings
  changeCurrentDay: (model, day, options) ->
    @$el.find('td.current').removeClass('current')
    @$el.find("td[data-day='#{day}']").addClass('current')

module.exports = CalendarView