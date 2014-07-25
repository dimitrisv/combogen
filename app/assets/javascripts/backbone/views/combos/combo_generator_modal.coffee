class LevelApp.Views.ComboGenerator extends Backbone.View
  @VIEW_URL: (options) -> "/get_generator_view?combo=#{options.combo_id}"

  initialize: ->
    @currentCombo = @$('.combo').first()

    @myTrickList = $.parseJSON($('#my-tricks').text())
    @dbTrickList = $.parseJSON($('#db-tricks').text())
    @allOfThem   = @myTrickList.concat(@dbTrickList)

    $('.combo-input-wrapper').selectize(
      persist: false,
      createOnBlur: true,
      create: true,
      hideSelected: false,
      enableDuplicate: true,
      labelField: "name",
      valueField: "name",
      searchField: ["name"],
      sortField: [
        { field: "name", direction: "asc" }
      ],
      options: @allOfThem
    )
    @selectize = $('.combo-input-wrapper')[0].selectize
    # 
    # selectize.setValue( existing combo )
    
    @$el.on('keyup', @noEscape)
    
  events:
    'click #add': 'addTricks'
    'click #save-combo': 'saveCombo'
    'click #discard': 'discard'

  addTricks: ->
    # add 'em bro!

  saveCombo: ->
    debugger
    comboSequence = $('.combo-input-wrapper').val()
    return if(comboSequence.length == 0 or comboSequence == undefined)

    $.ajax(
      url: '/combos',
      type: 'POST',
      data:
        sequence: comboSequence
      success: () =>
        LevelApp.modal.close()
    )

  discard: ->
    LevelApp.modal.close()

  noEscape: (evt) ->
    if evt.keyCode is 27
      evt.stopImmediatePropagation()