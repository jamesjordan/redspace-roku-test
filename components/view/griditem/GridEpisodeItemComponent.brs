sub init()
    m.style = GetStyle("grid--item")

    m.poster = m.top.FindNode("poster")
    m.titleLabel = m.top.FindNode("titleLabel")

    m.top.observeField("itemContent", "OnContentSet")
    m.top.observeField("focusPercent", "showfocus")
    m.top.observeField("rowFocusPercent", "showfocus")
    m.top.observeField("rowHasFocus", "showfocus")
    m.top.observeField("rowListHasFocus", "showfocus")
    m.top.observeField("gridHasFocus", "showfocus")
end sub

sub OnContentSet()
    m.itemContent = m.top.itemContent
    uiResolution = m.global.uiResolution.name
    dims = [250, 140]
    
    m.poster.uri = m.itemContent.image.medium
    m.poster.width = dims[0]
    m.poster.height = dims[1]

    m.titleLabel.text = m.itemContent.name
    m.titleLabel.width = dims[0]
    m.titleLabel.translation = [0, dims[1] + 15]
end sub

sub showfocus()

end sub
