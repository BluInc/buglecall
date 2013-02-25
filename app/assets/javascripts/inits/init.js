//handlebars_assets generates the HandlebarsTemplates object
//alias it so Thorax can use it
Thorax.templates = HandlebarsTemplates;

// Create the Application object, Application.setView() will
// place a view inside the {{layout}}
var Application = window.Application = new Thorax.LayoutView({
  name: 'application'
});

// Alias the special hashes for naming consitency
Application.templates = Thorax.templates;
Application.Views = Thorax.Views;
Application.Models = Thorax.Models;
Application.Collections = Thorax.Collections;

// Allows load:end and load:start events to propagate
// to the application object
Thorax.setRootObject(Application);

$(function() {
  // Application and other templates included by the base
  // Application may want to use the link and url helpers
  // which use hasPushstate, etc. so setup history, then
  // render, then dispatch
  Backbone.history.start({
    pushState: false,
    root: '/',
    silent: true
  });
  Application.appendTo('body');
  Backbone.history.loadUrl();

  //Enable Tool Tips
  $("[data-toggle=tooltip]").tooltip();
});