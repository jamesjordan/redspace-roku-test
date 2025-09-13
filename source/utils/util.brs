function getComponentXAxisParentCenter(parentWidth, componentWidth)
  if (parentWidth = invalid or componentWidth = invalid)
    return invalid
  end if
  axisCenter = (parentWidth / 2) - (componentWidth / 2)

  return axisCenter
end function

function getComponentYAxisParentCenter(parentHeight, componentHeight)
  if (parentHeight = invalid or componentHeight = invalid)
    return invalid
  end if
  axisCenter = (parentHeight / 2) - (componentHeight / 2)

  return axisCenter
end function

function percentToNumber(percent, value)
  if (percent = invalid or value = invalid)
    return invalid
  end if
  dec = percent / 100
  number = value * dec

  return number
end function

function setPaletteStyles() as object
  colors = GetStyleForUtil("dialog--pallet--primary")
  paletteCollection = {}
  coloredPalettePRIMARY = createObject("roSGNode", "RSGPalette")
  coloredPalettePRIMARY.colors = {
      DialogBackgroundColor: colors.DialogBackgroundColor,
      DialogFocusColor: colors.DialogFocusColor,
      DialogFocusItemColor: colors.DialogFocusItemColor,
      DialogTextColor: colors.DialogTextColor
  }
  
  colors = GetStyleForUtil("dialog--pallet--primarylight")
  coloredPalettePRIMARYLight = createObject("roSGNode", "RSGPalette")
  coloredPalettePRIMARYLight.colors = {
    DialogBackgroundColor: colors.DialogBackgroundColor,
    DialogFocusColor: colors.DialogFocusColor,
    DialogFocusItemColor: colors.DialogFocusItemColor,
    DialogTextColor: colors.DialogTextColor
  }

  paletteCollection = {
      coloredPalettePRIMARY: coloredPalettePRIMARY,
      coloredPalettePRIMARYLight: coloredPalettePRIMARYLight
  }
  return paletteCollection
end function

sub addOrUpdateGlobal(field, value)
  ob = {}
  ob[field] = value
  m.global.update(ob, true)
end sub

function GetStyleForUtil(styleName as string) as object
    styleOb = m.global.styles[styleName]
    'typography = GetTypography(styleOb.typography)

    'TODO:Is there a quicker way to copy the object? Is this slow? 
    styleStr = FormatJson(styleOb)
    newStyle = ParseJson(styleStr)
    'newStyle.FONT = typography.font
    
    return newStyle
end function

' TODO: Move to utils
' HTML -> plain text (safe for BrightScript regex)
function HtmlToText(html as dynamic) as String
    if type(html) <> "roString" and type(html) <> "String" then return ""

    s = html

    ' 1) Normalize line breaks for common block tags -> \n
    s = CreateObject("roRegex", "(?i)<br\\s*/?>", "i").ReplaceAll(s, chr(10))
    s = CreateObject("roRegex", "(?i)</p\\s*>", "i").ReplaceAll(s, chr(10))
    s = CreateObject("roRegex", "(?i)</div\\s*>", "i").ReplaceAll(s, chr(10))
    s = CreateObject("roRegex", "(?i)</li\\s*>", "i").ReplaceAll(s, chr(10))
    s = CreateObject("roRegex", "(?i)<li\\b[^>]*>", "i").ReplaceAll(s, "• ")

    ' 2) Strip all remaining tags
    s = CreateObject("roRegex", "<[^>]+>", "i").ReplaceAll(s, "")

    ' 3) Decode common HTML entities
    s = HtmlDecodeEntities(s)

    ' 4) Whitespace cleanup (no backslash escapes!)
    '    Normalize CR to LF, tabs/NBSPs to spaces, then collapse multiples.
    s = s.Replace(chr(13), chr(10)) ' CR -> LF
    s = s.Replace(chr(9), " ")      ' TAB -> space
    s = s.Replace(chr(160), " ")    ' NBSP -> space

    ' Collapse multiple spaces
    s = CreateObject("roRegex", " {2,}", "").ReplaceAll(s, " ")
    ' Collapse multiple newlines
    s = CreateObject("roRegex", chr(10) + "{2,}", "").ReplaceAll(s, chr(10))

    ' Trim leading/trailing whitespace (uses ifStringOps.Trim)
    s = s.Trim()

    return s
end function

' TODO: Move to utils
' Minimal entity decode for typical API summaries
function HtmlDecodeEntities(s as String) as String
    s = CreateObject("roRegex", "&nbsp;", "i").ReplaceAll(s, " ")
    s = CreateObject("roRegex", "&amp;",  "i").ReplaceAll(s, "&")
    s = CreateObject("roRegex", "&lt;",   "i").ReplaceAll(s, "<")
    s = CreateObject("roRegex", "&gt;",   "i").ReplaceAll(s, ">")
    s = CreateObject("roRegex", "&quot;", "i").ReplaceAll(s, chr(34))
    s = CreateObject("roRegex", "&apos;|&#39;", "i").ReplaceAll(s, "'")
    return s
end function