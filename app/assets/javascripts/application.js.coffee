#= require jquery
# require jquery_ujs /// !!! not being loaded here; comes with jquery-rails, which i try to avoid
#= require jquery.imagesloaded
# require underscore
#= require lodash
#= require hamlcoffee
#= require backbone
#= require backbone.marionette
#= require backbone-relational

#= require_tree ./templates

#= require initialisation
#= require setup/app
#= require setup/gallery
#= require_tree ./backbone/models
#= require_tree ./backbone/collections
#= require_tree ./backbone/views
#= require_tree ./backbone/routers

#= require jquery_events
#= require galleries
