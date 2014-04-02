class Application.Presenters.CommentsPresenter extends Transponder.Presenter
  presenterName: 'comments'
  module: 'application'

  create: ->
    $(@element).append(@response)
    $("#comment_body").val("")