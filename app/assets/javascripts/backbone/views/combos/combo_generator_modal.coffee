class LevelApp.Views.ComboGenerator extends Backbone.View
  @VIEW_URL: (options) -> "/get_generator_view?combo=#{options.combo_id}"

  initialize: ->
    @currentCombo = @$('.combo').first()

    @myTrickList = $.parseJSON($('#my-tricks').text())
    @dbTrickList = $.parseJSON($('#db-tricks').text())
    @allOfThem   = @myTrickList.concat(@dbTrickList)

    $('.combo-input-wrapper').selectize(
      plugins: ['remove_button', 'restore_on_backspace', 'drag_drop'],
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
    #@selectize.setValue( '540,540,540' )
    
    # Create combo with specific trick
    if window.location.hash
      trickName = window.location.hash.split('/')[1].replace(/_/g, ' ')
      unless trickName == undefined
        @selectize.addItem(trickName)

    # Focus on input
    setTimeout((=>@selectize.focus()), 200)
    
  events:
    'click #add': 'addTricks'
    'click #save-combo': 'saveCombo'
    'click #discard': 'discard'

  addTricks: ->
    numTricks = $('#no_tricks').val()
    list = $('#trick-list select').val()

    collection = if list == 'database' then @dbTrickList else @myTrickList
    
    i = 0
    while i < numTricks
      trick = collection[Math.floor(Math.random()*collection.length)]
      @selectize.addItem(trick.name)
      i++

  saveCombo: ->
    comboSequence = $('.combo-input-wrapper').val()
    return if(comboSequence.length == 0 or comboSequence == undefined)

    $.ajax(
      url: '/combos',
      type: 'POST',
      data:
        sequence: comboSequence
      success: (resp) =>
        if $('.list .list-row h3').length > 0
          $('.list .list-row').remove()
        $('#combos-list .list').prepend(resp)
        LevelApp.modal.close()
    )

  discard: ->
    LevelApp.modal.close()
