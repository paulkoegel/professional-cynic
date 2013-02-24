#= require jquery
#= require jquery_ujs
#= require cryptojs.sha256
#= require jquery.imagesloaded
#= require underscore
#= require hamlcoffee
#= require backbone
#= require backbone.marionette
#= require backbone-relational
#= require exif_reader

#= require_tree ./templates

#= require initialisation
#= require setup/app
#= require setup/gallery
# giving me pain on Heroku (line 17 was the one with backbone/collection) - folder's probably lacking a .gitkeep
# require_tree argument must be a directory
#   (in /tmp/build_1rga7dj37xb5r/app/assets/javascripts/application.js.coffee:17) 
# require_tree ./backbone/models
# require_tree ./backbone/collections
# require_tree ./backbone/views
# require_tree ./backbone/routers

#= require jquery_events
