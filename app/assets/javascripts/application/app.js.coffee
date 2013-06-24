# Define and setup our application!
@.App = new Application
  # This is run before the DOM or application is ready, it is provided to allow you
  # to preload anything your application might need but is not depended on the DOM.
  initialize : () ->
    null
  # The ready method if fired after the initalize and after the DOM is ready but before main.
  ready : () ->
    # Application and other templates included by the base
    # Application may want to use the link and url helpers
    # which use hasPushstate, etc. so setup history, then
    # render, then dispatch
    Backbone.history.start
      pushState: false
      root: "/"
      silent: true

    Backbone.history.loadUrl()

    #Enable Tool Tips
    $("[data-toggle=tooltip]").tooltip()

    #Enable the Jquery UI Date Picker
    $(".datepicker").datepicker()

  # This method is executed when the enviroment call stack is finished and the DOM is
  # ready. Effectivly this is the start of you application.
  main : () ->
    # Binds the application viewport to the div with the given css selector
    @.setViewport(".main.client.application", 'application')

    # Below is an example on how to navigate on the client with URL's using the Backbone Router
    # @.router().navigate("index", {trigger: true}) 
    # or if you are outside of the application object
    # App.router().navigate("index", {trigger: true})

    # Below is an example on how to render an application view into a layout/view
    # @.getApplicationView('application').view.setView(new App.Views["example/test"]())


