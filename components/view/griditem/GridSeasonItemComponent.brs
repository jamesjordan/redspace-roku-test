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
    dims = [250, 50]

    m.titleLabel.text = "Season " + m.itemContent.id
    m.titleLabel.width = dims[0]
    m.titleLabel.translation = [0, 0]
end sub

sub showfocus()

end sub
