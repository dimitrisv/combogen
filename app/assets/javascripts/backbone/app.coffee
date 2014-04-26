window.LevelApp =
  Models: {}
  Views: {}
  initialize: ->
    LevelApp.router = new LevelApp.Router()
    LevelApp.modal  = new LevelApp.Views.Modal(
      el: $('#levelapp-modal')
    )
    Backbone.history.start(pushState: true)

class LevelApp.Router extends Backbone.Router
  routes:
    '': 'test'
    "my_combos": "myCombos"

  myCombos: ->
    LevelApp.currentView = new LevelApp.Views.MyCombos(
      el: $('#combos-wrapper')
    )

  test: () ->
    # alert('welcome to backbone!')
