class LevelApp.Views.Trick extends Backbone.View

  events:
    'click #more-to-try, #more-related': 'fetchCombos'

  fetchCombos: (evt) ->
    combos_type = evt.currentTarget.id
    $.ajax(
      url:  "/tricks/#{@id}/fetch_combos",
      type: "GET",
      data:
        combos_type: combos_type
      success: (resp) =>
        target = if combos_type == 'more-to-try' then '#try-these' else '#related-combos'
        @$("#{target} .list").remove()
        @$(target).append(resp)
      error: ->
        alert('Failed to fetch combos. Please refresh the page and try again!')
    )
