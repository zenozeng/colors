class Color

  # new Color("rgb(255, 138, 161)")
  constructor: (str) ->
    # "rgb(255, 138, 161)"
    regexpRGB = new RegExp('rgb\\(([0-9]*), ([0-9]*), ([0-9]*)\\)')
    if regexpRGB.test str
      [rgb, @r, @g, @b] = str.match(regexpRGB)

    # "rgba(0, 117, 94, 0.901961)"
    regexpRGBA = new RegExp('rgba\\(([0-9]*), ([0-9]*), ([0-9]*), ([0-9\.]*)\\)')
    if regexpRGBA.test str
      [rgb, @r, @g, @b, @a] = str.match(regexpRGBA)

    # "#fff"
    regexpHEX3 = new RegExp('#([0-9a-fA-F]{3})')
    if regexpHEX3.test str
      [str, hex] = str.match regexpHEX3
      str = "##{hex}#{hex}"

    # "#00755E"
    regexpHEX6 = new RegExp('#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})')
    if regexpHEX6.test str
      [hex, @r, @g, @b] = str.match regexpHEX6
      @r = parseInt(@r, 16)
      @g = parseInt(@g, 16)
      @b = parseInt(@b, 16)

    unless @r? and @g? and @b?
      throw new Error('Invalid Color Format')

    # parse
    @r = parseInt(@r)
    @g = parseInt(@g)
    @b = parseInt(@b)

  hex: ->
    hex = "#"
    if @a? #rgba
      for elem in [@r, @g, @b]
        elem = elem * @a + 255 * (1 - @a)
        elem = parseInt elem, 10
        hex += '0' if elem < 16
        hex += elem.toString(16)
    else #rgb
      for elem in [@r, @g, @b]
        hex += '0' if elem < 16
        hex += elem.toString(16)
    hex.toUpperCase()

  rgb: (split = ', ') ->
    [@r, @g, @b].join split

@Color = Color
