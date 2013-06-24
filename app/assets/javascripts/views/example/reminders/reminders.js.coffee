App.View.extend (
  name: 'example/reminders/reminders'
  tagName: 'table'
  attributes:{
    class: "table table-condensed table-hover"
  }

  initialize: () ->
    _.bindAll @, "render"
    
    if ! _.has(@, 'collection')
      @.collection = new App.Collections.Reminders()
      @.collection.parent = App.get('CurrentUser')

    # This view should listen to the collection to see when it reloads it's data.
    @.listenTo @.collection, "sync add", @.render
    # @.collection.on "sync", @.render, @
    @.collection.fetch(
      'reset': true
    )

  # When loading dynamic data from the server it is best to overload the
  # render function of the view, this is an example of the correct way to do this.
  render: () ->
    # CLEAR OUT THE ELEMENT
    @.$el.empty()
    # CALL THE PARENT TO RENDER THE TEMPLATE
    App.View.prototype.render.apply @, arguments

    # APPEND THE RENDERED TEMPLATE TO THE CURRENT VIEW
    @.$el.html @.template

    # RENDER A VIEW FOR EACH ITEM IN THIS COLLECTION
    # NOTICE THE USE OF THE FAT ARROW => WHICH KEEPS THE CONTEXT OF THE VIEW IN @
    @.collection.each( (reminder) =>
      new App.Views["example/reminders/reminder"]({model: reminder}).appendTo @.$el
    )
    
    #RETURN THIS FOR CHAINING
    @
)