sub init()
    m.style = GetStyle("text-button")

    m.lbl = m.top.findNode("lbl")

    m.top.observeField("text", "onText")
    m.top.observeField("focusedChild", "onFocus")
end sub

sub onText()
    print "TextButton onText() m.top.text:"; m.top.text
    m.lbl.text = m.top.text
    m.lbl.color = m.style.color
    m.lbl.font = GetFont(m.style.focus_label_font)
    print "TextButton onText() GetFont(m.style.focus_label_font):"; GetFont(m.style.focus_label_font)
    print "TextButton onText() GetFont(m.style.unfocus_label_font):"; GetFont(m.style.unfocus_label_font)

    onFocus()
end sub

sub onFocus()
    print "TextButton onFocus() m.top.hasFocus():"; m.top.hasFocus()
    if(m.top.hasFocus())
        m.lbl.font = GetFont(m.style.focus_label_font)
    else 
        m.lbl.font = GetFont(m.style.unfocus_label_font)
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false
	if (press = true)
        if (key = "OK")
            m.top.selected = true
            handled = true
		end if
	end if
	return handled
end function
