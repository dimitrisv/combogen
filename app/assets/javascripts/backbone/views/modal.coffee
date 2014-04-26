class LevelApp.Views.Modal extends Backbone.View
  initialize: ->
    @$document = $(document)
    @$el.on('show.bs.modal', =>
      @$document.on('keyup', @closeModal)
    )
    @$el.on('hide.bs.modal', =>
      @$document.off('keyup', @closeModal)
      if @view isnt undefined
        @view.undelegateEvents()
        @view.stopListening()
        @view.clean() if 'clean' of @view
        @view.$el.html('')
        @view = undefined
    )

  events:
    'click': 'closeModal'

  show: (view, options={}) ->
    @$el.modal(
      backdrop: 'static'
      keyboard: false
    )
    @$('.content').addClass('loading')
    $.get(view.VIEW_URL(options)).done((resp) =>
      @$('.content').removeClass('loading')
      @$('.content').html(resp)
      @view = new view(
        _.extend(options,
          el: @$('.content')
        )
      )
    ).fail(=>
      alert('Operation failed! Please refresh the page and try again.')
      @$el.modal('hide')
    )

  close: -> 
    @$el.modal('hide')

  closeModal: (evt) =>
    # Return if buttun isn't esc
    if evt.type is 'keyup' and evt.keyCode isnt 27
      return
    if evt.type is 'click' and evt.currentTarget isnt evt.target
      return
    @close()


