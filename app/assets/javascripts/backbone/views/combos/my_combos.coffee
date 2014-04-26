class LevelApp.Views.MyCombos extends Backbone.View
  initialize: ->
    @currentList = $('#combo-lists-dropdown').val()

  events:
    'change #combo-lists-dropdown': 'updateList'
    'click #load-view': 'openComboGeneratorModal'

  updateList: (evt) ->
    newList = $('#combo-lists-dropdown').val()
    if newList isnt @currentList
      @currentList = newList
      $.get("my_combos?list=#{newList}").done((resp)=>
        @$('#combos-list').html(resp)
      )

  openComboGeneratorModal: (evt) ->
    evt.preventDefault()
    LevelApp.modal.show(LevelApp.Views.ComboGenerator,
      combo_id: 0
    )