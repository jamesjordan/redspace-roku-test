sub init()
    m.style = GetStyle("grid--hero-item")

    m.textLbl = m.top.findNode("textLbl")

    m.top.observeField("draw", "onDraw")
    m.top.observeField("enabled", "onEnabbled")
    m.top.observeField("focusedChild", "onFocus")
end sub

sub onFocus()
    if(m.top.hasFocus())
        m.moreBtn.setFocus(true)
    end if
end sub

sub onDraw()
    m.textLbl.font = GetFont(m.style.descriptionLabel_font)
    m.textLbl.color = m.style.descriptionLabel_color
    m.textLbl.text = m.top.text
end sub
