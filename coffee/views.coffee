class View

  constructor: (@colors) ->

  index: ->
    html = @colors.map (color) -> "<a href=\"#!/color/#{color.hex}\" style=\"background: ##{color.hex}\"></a>"
    $('#index').html html.join('\n')
    $('#color').slideUp -> $('#index').slideDown()

  color: (hex) ->
    color = @colors.filter (color) -> color.hex is hex
    color = color[0]
    html = ["##{color.hex}", color.name, color.cname].join('&nbsp;&nbsp;')
    $('#color p').first().html html

    window.less.modifyVars {'@color': '#'+hex}
    
    $('#index').slideUp -> $('#color').slideDown()
    

@View = View
