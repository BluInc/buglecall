# handlebars_assets generates the HandlebarsTemplates object
# alias it so Thorax can use it
Thorax.templates = Handlebars.templates = HandlebarsTemplates


$ ->
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