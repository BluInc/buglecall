Default Rails 3.2+ Starter Enviroment
=========================

This project is intended to help people rapidly deploy common rails configurations and offer as a good starting 
point to test out new ideas. This application is configured and able to run right out of the box.

It includes the following:

 * Twitter bootstrap: http://twitter.github.com/bootstrap/index.html and is initially styled with it.
 * Font Awesome http://fortawesome.github.com/Font-Awesome/ is included.
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
 * Can imeadiatly be deployed to Heroku, without any modifications.
 
This allows me to have a common starting point for new Rails applications I develop, and to quickly spinup a known state to test something new out.


Seeing Backbone / Thorax / Handelbars Work
==========================================

A test route has been pre-configured to work with this deployment. To see it in action simply fireup the application and add the following #/test to the url. For example something like this [http://localhost:3000/#/test](http://localhost:3000/#/test) .

Or you can do the following from your browsers javascript console to see how client side interaction feels:
```
   var view = new Application.Views['test/index']
   Application.setView(view)
```
That will grab the test routes index view and render it to the browser!



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
* You need to install ImageMagic in order to do the image processing, if you are using OS X do the following:
   ```
   brew install imagemagick
   ```
