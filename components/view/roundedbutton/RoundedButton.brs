sub init()
    m.style = GetStyle("rounded-button")
    m.uiResolution = m.global.uiResolution.name

    m.lbl = m.top.findNode("lbl")
    m.focusedImage = m.top.findNode("focused_image")
    m.unfocusedImage = m.top.findNode("unfocused_image")

    m.top.observeField("buttonType", "draw")
    m.top.observeField("enabled", "onEnabled")
    m.top.observeField("width", "setWidth")
    m.top.observeField("focusedChild", "onFocus")

    m.defaultWidth = 226
    m.defaultHeight = 68
end sub

sub setWidth()
    if(m.top.width <> invalid)
        m.focusedImage.width = m.top.width
        m.focusedImage.height = m.defaultHeight
        m.unfocusedImage.width = m.top.width
        m.unfocusedImage.height = m.defaultHeight
        m.lbl.width = m.top.width - 20
    end if
end sub

sub draw()
    m.lbl.text = m.top.text
    m.lbl.font = GetFont(m.style.label_font)
    m.lbl.color = m.style.color
    m.lbl.width = m.defaultWidth - 20
    m.lbl.height = m.defaultHeight

    m.focusedImage.width = m.defaultWidth
    m.focusedImage.height = m.defaultHeight

    m.unfocusedImage.width = m.defaultWidth
    m.unfocusedImage.height = m.defaultHeight

    setPosterImages()
    showFocused()
end sub

sub onEnabled()
    setPosterImages()
    showFocused()
end sub

sub setPosterImages()
    if(m.top.enabled = true)
        m.focusedImage.uri = "pkg:/images/roundedbuttons/button_primary_focus_" + m.uiResolution + ".9.png"
        m.unfocusedImage.uri = "pkg:/images/roundedbuttons/button_primary_unfocus_" + m.uiResolution + ".9.png"
    else
        m.focusedImage.uri = "pkg:/images/roundedbuttons/button_disabled_" + m.uiResolution + ".9.png"
        m.unfocusedImage.uri = "pkg:/images/roundedbuttons/button_disabled_" + m.uiResolution + ".9.png"
    end if
end sub

sub onFocus()
    showFocused()
end sub

sub showFocused()
    if(m.top.hasFocus())
        m.focusedImage.visible = true
        m.unfocusedImage.visible = false
    else
        m.focusedImage.visible = false
        m.unfocusedImage.visible = true
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if (press = true)
        if (key = "OK")
            m.top.selected = true
            handled = true
        end if
    end if
    return handled
end function
