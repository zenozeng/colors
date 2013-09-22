View = @View
Router = @Router
$ ->
  $.get 'colors.json', (colors) ->
    view = new View colors
    router = new Router
    routes =
      '': -> view.index()
      '#': -> view.index()
      "#!/color/:hex": (hex) -> view.color hex
    router.add routes
    router.dispatch()
