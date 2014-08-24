class LevelApp.Views.MyCombos extends Backbone.View
  initialize: ->
    @currentList = $('#combo-lists-dropdown').val()
    if window.location.hash.split('/')[0] == '#new'
      LevelApp.modal.show(LevelApp.Views.ComboGenerator,
        combo_id: 0
      )

  events:
    'change #combo-lists-dropdown': 'updateList'
    'click #create-combo': 'openComboGeneratorModal'
    'click .edit-combo': 'openComboEditorModal'

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

  openComboEditorModal: (evt) ->
    evt.preventDefault()
    LevelApp.modal.show(LevelApp.Views.ComboGenerator,
      combo_id: $(evt.currentTarget).data('id')
      sequence: $(evt.currentTarget).parents('.list-row').find('.combo-sequence').text()
    )