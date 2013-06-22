
@Application =  (options) ->

  _viewport = new Thorax.LayoutView 
    initialize: () ->
      _.bindAll @, "all"
      @.on "all", @.all, @
    
    'name': 'layouts/application'

    all: () -> 
      console.log "Application:Events", arguments

  _debug = false

  _templates = Thorax.templates
  _views = Thorax.Views
  _models = Thorax.Models
  _collections = Thorax.Collections
  _router = null

  _elements = {}

  _aliases = {}

  _signedIn = false;

  _registerClass = (klass, hash) ->
    $super = klass.extend
    klass.extend = () ->
      child = $super.apply(@, arguments)
      if (child.prototype.name) 
        hash[child.prototype.name] = child
      
      child

  @.log = () ->
    if _debug
      console.log.apply @, arguments

  @.router = () ->
    _router

  @.signedIn = (value) ->
    if _.isUndefined(value)
      _signedIn
    else
      _signedIn = value

  @.setCollectionClass = (collectionClass) ->
    @.Collection = collectionClass

  @.setModelClass = (modelClass) ->
    @.Model = modelClass

  @.setViewClass = (viewClass) ->
    @.View = viewClass

  @.set = (aliasName, Obj, overwrite) ->
    if !_.has(_aliases, aliasName)
      _aliases[aliasName] = Obj
    else if _.has(_aliases, aliasName) and (_.isUndefined(overwrite) || overwrite is true)
      _aliases[aliasName] = Obj


    _aliases[aliasName]

  @.get = (aliasName) ->
    if _.has(_aliases, aliasName)
      _aliases[aliasName]
    else
      null

  @.aliases = () ->
    _.keys _aliases

  @.pinApplicationViewToElement = (DOMSelector, viewName, view) ->
    _elements[viewName] =
      'view' : view
      'viewName' : viewName
      'selector' : DOMSelector
      'el': $(DOMSelector)

    _elements[viewName].view.appendTo(DOMSelector)

    view.trigger "View:Append", view, viewName, _elements[viewName].selector, _elements[viewName].el


  @.getApplicationView = (viewName) ->
    if _.has _elements, viewName
     _.clone _elements[viewName]

  @.bindApplicationView = (selector, viewName) ->
    @.pinApplicationViewToElement(selector, viewName, _viewport)

  # This will allow events to bubble to this Application viewport object
  Thorax.setRootObject(_viewport)
  

  # Define default data object classes.
  @.Collection = Thorax.Collection.extend(
    '__application__': @
    # This defines a generic relationship between RESTful mapps and model and collections
    'url': () ->
      if _.isUndefined(@, 'parent')
        "/#{@.name.toUnderscore().toLowerCase()}"
      else
        _.result(@.parent, 'url') + "/#{@.name.toUnderscore().toLowerCase()}"
  )
  @.Model = Thorax.Model.extend(
    '__application__': @
    'useRailsUrl' : false
    'toJSON': () ->
      if @.useRailsUrl
        name = @['name'].toUnderscore().toLowerCase()
        
        obj = {}
        
        if !_.isUndefined(name)
          obj[@['name'].toUnderscore()] = _.clone @.attributes
        else
          obj = _.clone @.attributes
      else
        obj = _.clone @.attributes
      obj

  )
  @.View = Thorax.View.extend({ '__application__': @})

  @.Models = {}
  @.Collections = {}
  @.Views = {}
  @.Routers = {}

  _registerClass(@.Model, @.Models)
  _registerClass(@.Collection, @.Collections)
  _registerClass(@.View, @.Views)
  _registerClass(Backbone.Router, @.Routers)

  # This method is run when the Object Application is created.
  _.extend @, 
    initialize : () ->
      null
  # This method is run when the Application is created and the DOM is ready but before main.
  _.extend @, 
    ready : () ->
      null
  # This method will automaticallbe run when the DOM is ready.
  _.extend @,
    main : () ->
      null

  # Apply the OPTIONS to the object after we are done setting the defaults.
  _.extend @, options
  
  # Need to return the new Application from the constructor.
  @.initialize.call(@)

  _.defer () =>
    $ =>
      if @.signedIn()
        @.ready.call(@)
        @.main.call(@)
        _router = new @.Routers.Application()
        _viewport.trigger "Application:Status:Up", @
  
  @