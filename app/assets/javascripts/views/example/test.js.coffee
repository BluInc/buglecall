App.View.extend (
  name: 'example/test'
  tagName: 'form'
  views: {}
  attributes:{}
  events: 
    'click .save':'save'
    'click .cancel':'cancel'
    'change input':'update'
  initialize: () ->
    _.bindAll @, "save", "update"
    @.model = App.get('CurrentUser')
    @.model.useRailsUrl = true
    @.render()

  update: (e) ->
    # Get data
    attribute = $(e.currentTarget).attr('name')
    value = $(e.currentTarget).val()
    # Updates the model
    @.model.set attribute , value, {silent:true}

  cancel: () ->
    _.each @.model.attributes, (value, key, lst) =>
      @.model.set(key, "")

    @.$el.val ''

  save: () ->
    @.model.save({},{
      success: (model, response) ->
        console.log "SUCCESS: ", model, response
      error: (model, response) ->
        console.log "ERROR: ", model, response
    })
)