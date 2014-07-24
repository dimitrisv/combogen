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
    $('#filter').selectize({})
    
  events:
    'click #add': 'addTricks'

  addTricks: ->
    # add 'em bro!

