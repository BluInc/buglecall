new (Backbone.Router.extend({
  routes: {
    'test': 'index'
  },
  index: function() {
    var view = new Application.Views['test/index'];
    Application.setView(view);
  }
}));