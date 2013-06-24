
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

  @.attachViewToElement = (DOMSelector, viewName, view) ->
    _elements[viewName] =
      'view' : view
      'viewName' : viewName
      'selector' : DOMSelector
      'el': $(DOMSelector)

    _elements[viewName].view.appendTo(DOMSelector)

    view.trigger "View:Append", view, viewName, _elements[viewName].selector, _elements[viewName].el


  @.getView = (viewName) ->
    if _.has _elements, viewName
     _.clone _elements[viewName]

  @.setViewport = (selector, viewName) ->
    @.attachViewToElement(selector, viewName, _viewport)

  # This will allow events to bubble to this Application viewport object
  Thorax.setRootObject(_viewport)
  

  # Define default data object classes.
  @.Collection = Thorax.Collection.extend(
    '__application__': @
    # This defines a generic relationship between RESTful mapps and model and collections
    'url': () ->
      if !_.has(@,'parent')
        "/#{@.name.toUnderscore().toLowerCase()}"
      else
        _.result(@.parent, 'url') + "/#{@.name.toUnderscore().toLowerCase()}"
  )
  @.Model = Thorax.Model.extend(
    '__application__': @
    'useRailsUrl' : false
    'nestedGet' : (attr) ->
      nestedAttributes = []
      index = attr.indexOf('.')
      last = 0
      while index > 0
        nestedAttributes.push attr.substring(last, index)
        last = index + 1
        index = attr.substring(last).indexOf('.')

      if nestedAttributes.length is 0
        m = @.attributes[attr]
      else
        # Need to grab the last one.
        nestedAttributes.push attr.substring(last)

        index = 0
        m = null
        while index < nestedAttributes.length
          if _.isNull(m)
            m = @.get(nestedAttributes[index])
          else
            m = m.get(nestedAttributes[index])
          index++

        m
    'nestedSet' : (attr, value, options) ->
      nestedAttributes = []
      index = attr.indexOf('.')
      last = 0
      while index > 0
        nestedAttributes.push attr.substring(last, index)
        last = index + 1
        index = attr.substring(last).indexOf('.')

      if nestedAttributes.length is 0
        console.log "SETTING:", attr, "TO:", value
        console.log "nestedAttributes:", nestedAttributes
        return @.set(attr, value, _.extend({silent:true}, options))
      else
        # Need to grab the last one, that is the property we are setting.
        setProperty = attr.substring(last)
        console.log "SETTING:", setProperty, "TO:", value
        console.log "nestedAttributes:", nestedAttributes
        index = 0
        m = null
        while index < nestedAttributes.length
          if _.isNull(m)
            m = @.get(nestedAttributes[index])
          else
            m = m.get(nestedAttributes[index])
          index++
      
        return m.set(setProperty, value, options)



    # This defines a generic relationship between RESTful mapps and parent child connections
    'url' : () ->
      if _.has(@, 'collection')
        base = _.result(@.collection, "url")
      else if _.has(@, 'parent')
        base = _.result(@.parent, 'url') + _.result(@, "urlRoot")
      else 
        base = _.result(@, "urlRoot")

      return base  if @.isNew()

      base + ((if base.charAt(base.length - 1) is "/" then "" else "/")) + encodeURIComponent(@id)

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
        if _.has(@.Routers, 'Application')
          _router = new @.Routers.Application()
        @.ready.call(@)
        @.main.call(@)
        _viewport.trigger "Application:Status:Up", @
  
  @