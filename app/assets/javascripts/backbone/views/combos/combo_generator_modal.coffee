class LevelApp.Views.ComboGenerator extends Backbone.View
  @VIEW_URL: -> "/get_generator_view?combo=#{options.combo_id}"

  initialize: ->
    # trick input autocomplete. fetch collection once, add to all inputs.
    alert('welcome to the world of tomorrow')


  