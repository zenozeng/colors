Color = @Color

class View

  constructor: (@colors) ->
    $('body').on 'click', '.color', ->
      color = $(this).css('background-color')
      color = new Color color
      hex = color.hex().split('#')[1]
      window.location.hash = "#!/color/#{hex}"

  index: ->
    html = @colors.map (color) -> "<a href=\"#!/color/#{color.hex}\" style=\"background: ##{color.hex}\"></a>"
    $('#index').html html.join('\n')
    $('#color').slideUp -> $('#index').slideDown()

  color: (hex) ->
    $('html, body').animate({scrollTop: 0})
    color = @colors.filter (color) -> color.hex is hex
    color = color[0]
    hex = "#"+hex
    prefix = "<a href=\"#\">Colors</a>"
    if color?
      html = [prefix, '&gt;', color.cname, color.name].join('&nbsp;&nbsp;')
    else
      html = [prefix, '&gt;', hex].join('&nbsp;&nbsp;')
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
