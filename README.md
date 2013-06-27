Default Rails Starter Enviroment
=========================

This project is intended to help people rapidly deploy common rails configurations and offer as a good starting 
point to test out new ideas. This application is configured and able to run right out of the box.

It includes the following:

 * Better Errors https://github.com/charliesome/better_errors really makes debugging your rails application much easier.
 * Twitter bootstrap: http://twitter.github.com/bootstrap/index.html and is initially styled with it.
 * Font Awesome http://fortawesome.github.com/Font-Awesome/ is included.
 * Redis is used for session management, this will help it scale in production.
 * All Rails views are using haml http://haml.info/ instead of erb.
 * Data Driven Documents for charting and graphing http://d3js.org/.
 * Amazon Web Services SDK to interface with Amazon http://aws.amazon.com/sdkforruby/.
 * Backbone for managing client side interactions http://backbonejs.org/.
 * Thorax which is built ontop of Backbone and provies some opinions http://thoraxjs.org/.
 * Handelbars which is what Thorax and backbone use for the client site templates http://handlebarsjs.com/ however the prefered way of writing client side temlates is with an extension of .hamlbars. This allows you to include haml that is preprocessed for handelbars, this saves you on a lot of html.
 * Devise https://github.com/plataformatec/devise is configured and ready to go with a User model.
 * Cancan https://github.com/ryanb/cancan is setup to controll access to resources, it uses a bitmask on the devise User model.
 * Basic routing setup.
 * Paperclip https://github.com/thoughtbot/paperclip , which is configured to store files using Amazon S3
 * PaperTrail https://github.com/airblade/paper_trail , which allows for tracking model changes.
 * File Uploader http://github.com/Valums-File-Uploader/file-uploader, allows for progressbar and drag-and-drop support.
 * Gritter for growl like client notifications https://github.com/jboesch/Gritter.
 * wysihtml5 for formatted text input http://jhollingworth.github.io/bootstrap-wysihtml5/.
 * Moment for date manipulation https://github.com/timrwood/moment.
 * bootstrap-editable In-place editing with Bootstrap Form and Popover https://github.com/vitalets/bootstrap-editable.
 * Sparklines Generates inline sparkline charts http://omnipotent.net/jquery.sparkline/.
 * Can imeadiatly be deployed to Heroku, without any modifications.
 
This allows me to have a common starting point for new Rails applications I develop, and to quickly spinup a known state to test something new out.

Getting Your Rails Enviroment (Mac Outline)
===
1. Make sure Xcode Command Line Tools are installed.
2. Make sure Homebrew is installed (`http://mxcl.github.io/homebrew/`).
3. Use homebrew to install Redis - `brew install redis`, I recommend starting it at login, follow the onscreen instructions.
4. Use homebrew to install elasticsearch - `brew install elasticsearch`, I recommend starting it at login, follow the onscreen instructions.
5. Use homebrew to install ImageMagic = `brew install imagemagick`, this is used to rezise images for paperclip.
6. Install Node Version Manager - NVM (`https://github.com/creationix/nvm`).
7. Install the latest stable version of Node.js with NVM.
8. Install Ruby Version Manager - RVM (`https://rvm.io/`)
9. Install the latest version of Ruby 1.9.3, This is what this library uses.
10. Clone or Fork this repo to your machine.
11. This project uses .ruby-version & .ruby-gemset to specify the ruby version and isolate your gemset related to this project.
12. Navigate to your project directory and run `bundle install` to install all the gems for the project, then run `rake db:migrate` to update the local db or `rake db:reset`.
13. To start your instance type `rails s`, this starts the rails server.

Client Application Info
========================
* The client side application is constructed and maintained by greplytix. It sets up a structure that it uses in it's deployments, feel free to modify or change it.
   * There are some modification made to the Backbone.Model, Backbone.Collection, Backbone.View, and Backbone.Router.
     * Models are located in `assets/javascript/models`, they generally need to always include two configurations: `name` and `urlRoot`.
       * This was designed to work out-of-the-box with a Rails backend but will work with any server technology. Generally speaking the Model name should be the same name as the matching Model in Rails. The urlRoot is as defined in the Backbone documentation, but should always be included.
       * Model definitions are collected at App.Models automatically. So if you specified a name of 'Setting' in the Model then you could define a new model with `new App.Models.Setting()`.
       * Model's have an added property called `useRailsUrl`, it is false by default. Setting this to true will overwrite the default `toJSON` to behave like Rails expects, placing the Model attributes within a properly named object.
       * If you set the `parent` property of a model to another instanciated Model it will construct nested URL's when communicating to the server. For example I might have in a View initialize method the follwoing:
          
          ```
          @.model = new App.Models.Address()
          @.model.parent = App.get('CurrentUser')
          @.model.useRailsUrl = true
          ```
          * Now the URL that is generated would be something like this `/users/1/addresses/`, it will nest the relationships with the routes.
       * Model's have a new attribute setter and getter called nestedSet & nestedGet. This allows you to work with nested Models, for example:
       
          ```
          @.model = new App.Models.User({person: new App.Models.Person()})
          @.model.useRailsUrl = true
          @.model.nestedSet('person.first_name', 'Joe')
          @.model.nestedSet('person.last_name', 'Viscomi')
          ...
          firstName = @.model.nestedGet('person.first_name')
          ```
     * Collections are located in `assets/javascript/collections`, they generally need to always include two configurations: `model` and `name`.
       * The `name` property is similar to the Model's `name` property. It should be plural, just as in Rails it refers to a table (basically).
       * The `model` property should be the class definition (constructor) of the Model this collection comproses of so something like `model: App.Models.Setting`.
       * If you set the `parent` property of a collection to another instanciated Model it will construct nested URL's when communicating to the server. For example I might have in a View initialize method the follwoing:
          
          ```
          @.collection = new App.Models.Settings()
          @.collection.parent = App.get('CurrentUser')
          ```
          * Now the URL that is generated would be something like this `/users/1/settings/`, it will nest the relationships with the routes.
  * The `Application` object here called `App` provides some useful helper methods.
    * App.set(aliasName, Obj, overwrite)
      * This assigned a name to the given object, overwrite is defaulted to true and tells the system weather to overwrite the existing aliasName if it exists already.
      * This is a common pattern:
         ```
         @.model = App.set('CurrentUser', new App.Models.User({id:1}))
         ```
    * App.get(aliasName)
      * This retrieves an object that was given an aliasName with App.set.
    * App.router()
      * Gives you access to the Application's Backbone.Router.
         `App.router().navigate("index", {trigger: true})`
    * App.attachViewToElement(DOMSelector, viewName, view)
      * This helper assigned a view a name, and binds it to the given DOM element.
    * App.getView(viewName)
      * This returns a views registered object, NOT just the view. This object looks like:
        
         ```
         {
           'view' : view
           'viewName' : viewName
           'selector' : DOMSelector
           'el': $(DOMSelector)
         }
         ```
         * view is the View Object, el is the jQuery handel on the view, selector is the DOM object the view is bound to.
    * App.setViewport(selector, viewName) 
      * This binds the application's viewport to the specified dom element, this is the main window of your application and is typically done once!
    * App.signedIn(value)
      * Tells the application if you are signedIn to the application. If you do not set a value (true/false) it will return the current signedIn state. 
* `assets/javascript/application/app.js.coffee` is where the application is defined.
   * It provides you three methods for you to override: `initialize`, `ready`, `main`
     *  `initialize` is executed before the DOM is ready, it runs when the Application object is created.
     *  `ready` is executed before `main` but after the DOM is ready, this is where you might include some other configurations.
     *  `main` is executed last, when `main` runs, everything should be setup for your application, essentially this is your applications entry point.
* `assets/javascript/routers/application.router.js.coffee` is where the application default Router is located, if you use the Backbone.Router in your applications this is what you modify.
* `assets/javascript/inits/` is where you would store files that are needed for pre-application configuration, please look at `assets/javascript/application.js` for execution order.
* 

Running the example application
==========================================

* After logging into the application open the javascript console on your browser and execute the following command to run the example application `App.router().navigate("index", {trigger: true})`



Notes
=====

* Don't for get to migrate the database and bundle install: `bundle install` and then `rake db:migrate`
* Signup on the site to create a User account, then give that user a security roll of dba by doing the following from the rails console:
 
   ```
   user = User.first
   user.roles = ["dba"]
   ```
* Setup your enviroment to store your Amazon S3 access keys, create a file in your home folder called .amazon_keys with the follow contents (use your own keys and bucket):
   ```
   export AWS_BUCKET='my_bucket'
   export AMAZON_ACCESS_KEY_ID='abcdefghijklmnop'
   export AMAZON_SECRET_ACCESS_KEY='1234567891012345'
   ```
   then modify your .bash_profile or .bashrc to source your file:
   ```
   ### Enable AWS Access Keys
   if [[ -f "$HOME/.amazon_keys" ]]; then
     source "$HOME/.amazon_keys";
   fi
   ```
* If you want to get improved debugging in the chrome developer panel, install the Chrome RailsPanel Extension.
