# This is the default application router.
Backbone.Router.extend(
  name: 'Application'
  routes:
    index: "index"

  index: () ->
    App.getApplicationView('application').view.setView(new App.Views["example/test"]())
)