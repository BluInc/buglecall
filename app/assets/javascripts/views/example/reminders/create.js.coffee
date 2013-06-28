App.View.extend (
  name: 'example/reminders/create'
  tagName: 'form'
  events: 
    'click .save':'save'
    'click .cancel':'cancel'
    'change input':'update'
  initialize: ->
    _.bindAll @, "save", "update", "cancel"
    if !_.has(@, 'model')
      @.model = new App.Models.Reminder
        name:''
        description:''
      @.model.parent = App.get('CurrentUser')
      @.model.useRailsParams = true

  update: (e) ->
    # Get data
    attribute = $(e.currentTarget).attr('name')
    value = $(e.currentTarget).val()
    index = attribute.indexOf('.')
    if index is -1
      # Updates the model directly
      @.model.set attribute , value, {silent:true}
    else
      # Update a nested model
      childModel = attribute.substring(0, index)
      childAttribute = attribute.substring(index + 1)
      @.model.get(childModel).set(childAttribute, value)

  cancel: () ->
    _.each @.model.attributes, (value, key, lst) =>
      @.model.set(key, "")

    @.$el.val ''

  save: ->
    # We want to copy the shared model because we are adding it to another views
    # collection and we don't want to get things mixed up once we add it.
    localModel = @.model.clone()
    localModel.parent = App.get('CurrentUser')
    localModel.useRailsParams = true

    # Only add it to the local collection view if if was saved to the server
    localModel.save({},{
      success: (model, response) =>
        # Add the model to the collection
        @.collection.add(model)
        # Clear the form and reset the model
        @.cancel()
    })
)