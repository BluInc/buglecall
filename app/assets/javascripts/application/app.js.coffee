# Define and setup our application!
@.App = new Application
    # This is run before the DOM or application is ready, it is provided to allow you
    # to preload anything your application might need but is not depended on the DOM.
    initialize : () ->
      
    # This method is executed when the enviroment call stack is finished and the DOM is
    # ready. Effectivly this is the start of you application.
    main : () ->
      # Binds the application viewport to the div with the given css selector
      @.bindApplicationView(".main.client.application", 'application')

      # Below is an example on how to navigate on the client with URL's using the Backbone Router
      # @.router().navigate("index", {trigger: true}) 
      # or if you are outside of the application object
      # App.router().navigate("index", {trigger: true})

      # Below is an example on how to render an application view into a layout/view
      # @.getApplicationView('application').view.setView(new App.Views["example/test"]())


