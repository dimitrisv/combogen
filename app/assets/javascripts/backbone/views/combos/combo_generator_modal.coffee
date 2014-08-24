class LevelApp.Views.ComboGenerator extends Backbone.View
  @VIEW_URL: (opts) -> "/get_generator_view?combo=#{opts.combo_id}"

  initialize: (opts) ->
    @opts = opts
    @currentCombo = @$('.combo').first()

    @selectizeComboInput()
    @selectizeListsInput()
    
    # Edit existing combo
    if !!opts.sequence > 0
      tricks = opts.sequence.split(' > ')
      for trickName in tricks
        @selectize.addItem(trickName)

    # Create combo with specific trick
    if window.location.hash
      trickName = window.location.hash.split('/')[1].replace(/_/g, ' ')
      unless trickName == undefined
        @selectize.addItem(trickName)

    # Focus on combo input
    setTimeout((=>@selectize.focus()), 200)
    
  events:
    'click #add': 'addTricks'
    'click #save-combo': 'saveCombo'
    'click #discard': 'discard'

  selectizeComboInput: ->
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

  selectizeListsInput: ->
    @myLists = $.parseJSON($('#my-lists').text())
    $('.list-input-wrapper').selectize(
      plugins: ['remove_button'],
      persist: false,
      createOnBlur: true,
      create: true,
      hideSelected: true,
      labelField: "name",
      valueField: "name",
      searchField: ["name"],
      sortField: [
        { field: "name", direction: "asc" }
      ],
      options: @myLists
    )

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
    if(comboSequence.length == 0 or comboSequence == undefined)
      alert('Combo is empty!')
      return

    lists = $('.list-input-wrapper').val()

    $.ajax(
      url: '/combos',
      type: 'POST',
      data:
        combo_id: @opts.combo_id
        sequence: comboSequence
        lists:    lists
      success: (resp) =>
        # Change to the default list + fetch the result
        listsDropdown = $('#combo-lists-dropdown')
        if listsDropdown.val() != ''
          # If we're viewing the 'All of them' list
          listsDropdown.val('')
          listsDropdown.trigger('change')
        else
          if !!@opts.sequence
            # delete existing entry
            $(".list-row[data-combo-id=#{@opts.combo_id}]").remove()
          $('#combos-list .list').prepend(resp)

        # TODO: Update number of combos in each list
        LevelApp.modal.close()
    )

  discard: ->
    LevelApp.modal.close()
