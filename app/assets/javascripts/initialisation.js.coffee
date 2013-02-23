'use strict'

# override Marionette's Renderer.render to allow usage of JST templates (HAML coffee in our case)
# cf. https://github.com/derickbailey/backbone.marionette/wiki/Using-jst-templates-with-marionette
Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template '" + template + "' not found!" unless JST[template]
  JST[template](data)

# initialise app and set namespace
window.PC = new Backbone.Marionette.Application()

$ ->
  PC.start()

PC.Models      = {}
PC.Collections = {}
PC.Routers     = {}
PC.Views       = {}
PC.Controllers = {}

# PC.vent = new Backbone.Marionette.EventAggregator()

class PC.AppLayout extends Backbone.Marionette.Layout
  template: 'layouts/application'
  el: '#l-game-container'
  regions:
    navigation:  '#l-header-container--navigation-wrapper'
    stack:   '#stack'
    piles:   '#l-piles-container'
    content: '#l-content-container'

PC.addInitializer (option) ->
  PC.setupApp()
