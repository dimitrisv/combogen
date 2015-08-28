window.LevelApp =
  Models: {}
  Views: {}
  initialize: ->
    LevelApp.router = new LevelApp.Router()
    LevelApp.modal  = new LevelApp.Views.Modal(
      el: $('#levelapp-modal')
    )
    Backbone.history.start(pushState: true)
    
    # Init toastr
    toastr.options = {
      "timeOut": "10000",
      "positionClass": "toast-top-center"
    }

class LevelApp.Router extends Backbone.Router
  routes:
    '': 'test'
    'tricks/:id': "trick"
    "my_combos": "myCombos"

  trick: (trick_id) ->
    LevelApp.currentView = new LevelApp.Views.Trick(
      el: $('#tricktionary-entry-wrapper'),
      id: trick_id
    )

  myCombos: ->
    LevelApp.currentView = new LevelApp.Views.MyCombos(
      el: $('#combos-wrapper')
    )

  test: () ->
    # alert('welcome to backbone!')
