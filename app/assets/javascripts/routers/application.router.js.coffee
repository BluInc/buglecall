# This is the default application router, update it to suite your needs.
Backbone.Router.extend(
  name: 'Application'
  routes:
    index: "index"

  index: () ->
    App.getApplicationView('application').view.setView(new App.Views["example/reminders/main"]())
)