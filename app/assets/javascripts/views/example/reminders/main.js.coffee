App.View.extend (
  name: 'example/reminders/main'
  initialize: () ->
    @.collection = new App.Collections.Reminders()
    @.collection.parent = App.get('CurrentUser')

    @.model = new App.Models.Reminder
      name:''
      description:''
  
    @.model.parent = App.get('CurrentUser')
    @.model.useRailsUrl = true
)