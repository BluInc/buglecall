App.View.extend (
  name: 'example/reminders/reminder'
  tagName: 'tr'
  views: {}
  attributes:{}
  events: 
    'click':'select'
  initialize: () ->
    # The view should listen to it's model for a change event.
    # Then call render when this occures so the view is up to date.
    @.listenTo @.model, "change", @.render

  select: (e) ->
    # CLEARS OUT THE PREVIOUS SELECTED/HILIGHTED ROW
    @.$el.parent().children('tr.info').removeClass("info")
    # SELECTS/HILIGHTS THE CURRENT ROW
    @.$el.addClass("info")
)