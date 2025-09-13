sub init()
  m.labelNode = m.top.findNode("label")

' m.style = GetStyle("default--textlabel")

  m.styleMap = {
    "bold": "pkg:/fonts/Gantari-Medium.ttf",
    "regular": "pkg:/fonts/Gantari-Regular.ttf"
  }

  updateFont()
end sub

sub onSizeChange()
  m.font.size = m.top.size
end sub

sub onStyleChange()
  updateFont()
end sub

sub updateFont()
  uri = m.styleMap[m.top.style]

  m.font = CreateObject("roSGNode", "Font")
  m.font.uri = uri
  m.font.size = m.top.size

  m.labelNode.font = m.font
end sub


sub setTextWidth()
  textRect = m.labelNode.boundingRect()
  m.top.textWidth = textRect.width
end sub
