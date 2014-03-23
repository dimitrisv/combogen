window.LevelApp =
  Models: {}
  Views: {}
  initialize: ->
    LevelApp.router = new LevelApp.Router()
    Backbone.history.start(pushState: true)

class LevelApp.Router extends Backbone.Router
  routes:
    "": "test"

  test: () ->
    alert('welcome to backbone!')
