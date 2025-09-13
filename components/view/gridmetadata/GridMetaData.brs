sub init() as void
    m.style = GetStyle("grid--hero-item")
    m.itemImage = m.top.findNode("heroTitlePoster")
    m.titleLbl = m.top.findNode("titleLbl")
    m.metaLayoutGroup = m.top.findNode("metaLayoutGroup")
    m.descriptionText = m.top.findNode("descriptionText")

    m.top.observeField("topPadding", "onTopPadding")
    m.top.observeField("itemData", "onItemData")
    m.top.observeField("focusedChild", "onFocus")
end sub

sub onFocus()
    print "GridMetaData m.watchBtn:"; m.watchBtn
    if(m.top.hasFocus())
        if( m.descriptionText <> Invalid)
            m.descriptionText.setFocus(true)
        end if
    end if
end sub

sub onTopPadding()
    topPadding = m.top.topPadding
    m.titleLbl.translation = [160, topPadding]
    m.metaLayoutGroup.translation = [160, topPadding + 160]
    m.descriptionText.translation = [160, topPadding + 194]
end sub

sub onItemData()
    itemData = m.top.itemData

    m.itemImage.width="810"
    m.itemImage.height="1080"
    m.itemImage.uri = itemData.posterUri
    
    m.titleLbl.font = GetFont(m.style.titleLabel_font)
    m.titleLbl.color = m.style.titleLabel_color
    m.titleLbl.text = itemData.title

    m.descriptionText.text = itemData.description
    if(m.top.longDescription)
        m.descriptionText.numLines = 5
        m.descriptionText.enabled = true
    end if
    m.descriptionText.draw = true
   
    showMetaData(itemData)
end sub

sub showMetaData(itemData)
    children = m.metaLayoutGroup.getChildCount()
    m.metaLayoutGroup.removeChildrenIndex(children, 0)

    strValues = []
    if(itemData.date <> Invalid)
        dateTime = createObject("roDateTime")
        dateTime.fromISO8601String(itemData.date)
        formattedDateStr = FormatDateTime(dateTime, "MMM D, YYYY")
        strValues.push(formattedDateStr)
    end if
    if(itemData.duration <> Invalid)
        durationStr = GetDurationString(itemData.duration)
        print "GridMetaData durationStr:"; durationStr
        strValues.push(durationStr)
    end if
    if(itemData.genre <> Invalid)
        strValues.push(itemData.genre)
    end if

    for i = 0 to strValues.count() - 1
        if(m.metaLayoutGroup.getChildCount() > 0)
            ellipsePoster = CreateObject("roSGNode", "Poster")
            ellipsePoster.uri = "pkg:/images/ellipse.png"
            ellipsePoster.width = 6
            ellipsePoster.height = 6
            m.metaLayoutGroup.appendChild(ellipsePoster)
        end if

        lbl = CreateObject("roSGNode", "Label")
        lbl.font = GetFont(m.style.metaLabel_font)
        lbl.color = m.style.metaLabel_color
        lbl.text = strValues[i]
        m.metaLayoutGroup.appendChild(lbl)
    end for
end sub

sub itemContentChanged()
    uiResolution = m.global.uiResolution
    itemData = m.top.itemData
    if (itemData.bannerImage <> invalid and itemData.bannerImage <> "")
        'TODO JJ: Check params at end of url
        if (uiResolution.name = "FHD")
            m.itemImage.uri = itemData.bannerImage + "?height=480"
        else if (uiResolution.name = "HD")
            m.itemImage.uri = itemData.bannerImage + "?width=1280"
        end if
    else if (uiResolution.name = "FHD")
        m.itemImage.uri = "pkg:/images/loaderPosterFHD.png"
    else if (uiResolution.name = "HD")
        m.itemImage.uri = "pkg:/images/loaderPosterHD.png"
    end if
    
end sub
