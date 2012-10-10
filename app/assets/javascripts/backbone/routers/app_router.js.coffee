'use strict'

class PC.Routers.AppRouter extends Backbone.Marionette.AppRouter
  initialize: ->

  routes:
    '': 'root'

  root: ->
    PC.appLayout = new PC.AppLayout()
    PC.appLayout.render()
    PC.appLayout.navigation.show new PC.Views.NavigationShow()
    PC.setupGallery
