# http://stackoverflow.com/questions/985272/jquery-selecting-text-in-an-element-akin-to-highlighting-with-your-mouse/987376#987376
# usage
# selectText document.getElementById('xxx')
@selectText = (element) ->
  doc = window.document
  if doc.body.createTextRange?
    # IE
    range = doc.body.createTextRange()
    range.moveToElementText element
    range.select()
  else
    if window.getSelection?
      selection = window.getSelection()
      range = doc.createRange()
      range.selectNodeContents element
      selection.removeAllRanges()
      selection.addRange range
