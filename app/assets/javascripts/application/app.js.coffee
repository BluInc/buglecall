# Define and setup our application!
@.App = new Application
    initialize : () ->
      #
    main : () ->
      @.bindApplicationView(".main.client.application", 'application')

      @.getApplicationView('application').view.setView(new App.Views["example/test"]())


