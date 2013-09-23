Color = @Color

class View

  constructor: (@colors) ->

  index: ->
    html = @colors.map (color) -> "<a href=\"#!/color/#{color.hex}\" style=\"background: ##{color.hex}\"></a>"
    $('#index').html html.join('\n')
    $('#color').slideUp -> $('#index').slideDown()

  color: (hex) ->
    color = @colors.filter (color) -> color.hex is hex
    color = color[0]
    hex = "#"+hex
    html = [color.cname, color.name].join('&nbsp;&nbsp;')
    $('#color h1').html html

    color = new Color hex
    [r, g, b] = color.rgb(',').split(',')

    vars =
      "@color": hex
      "@r": r
      "@g": g
      "@b": b
    window.less.modifyVars vars
    $('.color').each ->
      color = new Color $(this).css('background-color')
      id = $(this).attr('id')
      id = if id? then id.toUpperCase() else ''
      $(this).html "<p class=\"info\">#{id} <span>#{color.hex()}</span></p>"
    $('#index').slideUp -> $('#color').slideDown()
    

@View = View
