class LevelApp.Views.ComboGenerator extends Backbone.View
  @VIEW_URL: (options) -> "/get_generator_view?combo=#{options.combo_id}"

  initialize: ->
    # trick input autocomplete. fetch collection once, add to all inputs.
    @currentCombo = @$('.combo').first()
    $('.control-group').selectize(
      persist: false,
      createOnBlur: true,
      create: true
    )
    
  events:
    'click .remove': 'removeTrick'
    'click #add': 'addTrick'

  addTrick: ->
    unless @currentCombo.children().length is 0
      @currentCombo.children().last().append('>')
      @currentCombo.children().last().addClass('linked')
    numTricks = parseInt(@$('#no_tricks').val())
    for i in [1..numTricks-1]
      @currentCombo.append(
        """
          <div class="trick-input-container linked">
            <input class="trick-input">
            <a class="remove">X</a>
            &gt;
          </div>
        """
      )
    @currentCombo.append(
      """
        <div class="trick-input-container">
          <input class="trick-input">
          <a class="remove">X</a>
        </div>
      """
    )

  removeTrick: (evt) ->
    @$(evt.currentTarget).parents('.trick-input-container').remove()
    unless @currentCombo.children().length is 0
      # REMOVE THE GREATER THAN SYMBOL
      #
      #@currentCombo.children().last().removeClass('linked')
      console.log('not implemented yet')
