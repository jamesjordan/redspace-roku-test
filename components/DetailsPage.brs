sub init()
    m.style = GetStyle("content-page")

    m.episodesBackground = m.top.findNode("episodesBackground")
    m.gridMetaData = m.top.findNode("gridMetaData")
    m.episodeGroup = m.top.findNode("episodeGroup")
    m.markupGridList = m.top.findNode("markupGridList")
    m.markupGridSeasons = m.top.findNode("markupGridSeasons")
    m.gridMetaData.longDescription = true

    m.top.observeField("pageData", "onPageData")
    m.top.observeField("episodeData", "onEpisodeData")
    m.top.observeField("focusedChild", "onFocus")

    m.markupGridList.observeField("itemSelected", "onEpisodeGridItemSelected")
    m.markupGridSeasons.observeField("itemSelected", "onSeasonGridItemSelected")
end sub

sub onFocus()
    if(m.top.hasFocus())
        if( m._currentFocus <> Invalid)
            m._currentFocus.setFocus(true)
        end if
    end if
end sub

sub onPageData()
    pageData = m.top.pageData
    if (pageData <> invalid)
        metaData = {}
        metaData.title = pageData.name
        metaData.posterUri = pageData.image.original
        metaData.description = HtmlToText(pageData.summary)

        dt = DateFromYMD(pageData.premiered)
        premierd = ""
        if dt <> invalid
            ' e.g., print as ISO basic or seconds since epoch:
            ? dt.ToISOString()
            ? dt.AsSeconds()
            premierd = dt.ToISOString()
        end if
        metaData.date = premierd

        metaData.duration = pageData.averageRuntime * 60
        metaData.genre = pageData.genres[0] ' TODO: Add all genres

        print "DetailsPage onPageData metaData:"; metaData
        m.gridMetaData.itemData = metaData
        m.gridMetaData.visible = true
    end if

    watchBtn = CreateObject("roSGNode", "RoundedButton")
    watchBtn.observeField("selected", "onWatchButtonSelected")
    watchBtn.text = "Watch Now"
    watchBtn.buttonType = "primary"
    watchBtn.width = 242
    watchBtn.translation = [160, 604]
    m.top.appendChild(watchBtn)
    m.watchBtn = watchBtn
    m.watchBtn.setFocus(true)
    m._currentFocus = m.watchBtn

    addEpisodeButton()
end sub

sub onEpisodeData()
    createSeasonsGrid(m.top.episodeData.seasons)
    selected = 0
    selectedContent = m.markupGridSeasons.content.getChild(selected)
    episodes = m.top.episodeData.episodes[selectedContent.id]
    createGrid(episodes)
end sub

sub onSeasonGridItemSelected()
    print "onSeasonGridItemSelected"; m.markupGridSeasons.itemSelected
    selected = m.markupGridSeasons.itemSelected
    selectedContent = m.markupGridSeasons.content.getChild(selected)
    episodes = m.top.episodeData.episodes[selectedContent.id]
    createGrid(episodes)
end sub

sub onEpisodeGridItemSelected()
    print "onEpisodeGridItemSelected"; m.markupGridList.itemSelected
    selected = m.markupGridList.itemSelected
    selectedContent = m.markupGridList.content.getChild(selected)
    m.top.watchNow = {name:selectedContent.name}
end sub

sub createSeasonsGrid(gridDataArray)
    m.markupGridSeasons.content = invalid

    gridData = {}
    gridData.children = gridDataArray

    if(gridData <> invalid and gridData.children <> invalid)
        m.markupGridSeasons.numColumns = 1
        m.markupGridSeasons.itemSize = [150, 50]
        m.markupGridSeasons.itemSpacing = [0, 10]

        m.markupGridContent = createObject("roSGNode", "ContentNode")
        m.markupGridContent.Update({
            children: gridData.children
        }, true)

        m.markupGridSeasons.content = m.markupGridContent
    end if
end sub

sub createGrid(gridDataArray)
    m.markupGridList.content = invalid

    gridData = {}
    gridData.children = gridDataArray

    if(gridData <> invalid and gridData.children <> invalid)
        m.markupGridList.numColumns = 1
        m.markupGridList.itemSize = [250, 140]
        m.markupGridList.itemSpacing = [24, 80]

        m.markupGridContent = createObject("roSGNode", "ContentNode")
        m.markupGridContent.Update({
            children: gridData.children
        }, true)

        m.markupGridList.content = m.markupGridContent
    end if
end sub

sub addEpisodeButton()
    episodesBtn = CreateObject("roSGNode", "RoundedButton")
    episodesBtn.observeField("selected", "onEpisodesButtonSelected")
    episodesBtn.text = "Episodes"
    episodesBtn.buttonType = "primary"
    episodesBtn.width = 242
    episodesBtn.translation = [160, 700]
    m.top.appendChild(episodesBtn)
    m.episodesBtn = episodesBtn
end sub

sub onWatchButtonSelected()
    print "Watch button selected. Implement playback logic here."
    m.top.watchNow = m.top.pageData
end sub

sub onEpisodesButtonSelected()
    showEpisodesView()
end sub

sub showEpisodesView()
    m.episodeGroup.visible = true
    m.markupGridSeasons.setFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if (press = true)
        if (key = "up")
            if(m.watchBtn.hasFocus())
                m.gridMetaData.setFocus(true)
                m._currentFocus = m.gridMetaData
                handled = true
            else if(m.episodesBtn.hasFocus())
                m.watchBtn.setFocus(true)
                m._currentFocus = m.watchBtn
                handled = true
            end if
        else if (key = "down")
            if(m.gridMetaData.isInFocusChain())
                m.watchBtn.setFocus(true)
                m._currentFocus = m.watchBtn
                handled = true
            else if(m.watchBtn.hasFocus())
                m.episodesBtn.setFocus(true)
                m._currentFocus = m.episodesBtn
                handled = true
            end if
        else if (key = "right")
            if(m.markupGridSeasons.isInFocusChain())
                m.markupGridList.setFocus(true)
                m._currentFocus = m.markupGridList
                handled = true
            end if
        else if (key = "left")
            if(m.markupGridList.hasFocus())
                m.markupGridSeasons.setFocus(true)
                m._currentFocus = m.markupGridSeasons
                handled = true
            else if(m.markupGridSeasons.hasFocus())
                m.episodesBtn.setFocus(true)
                m._currentFocus = m.episodesBtn
                m.episodeGroup.visible = false
                handled = true
            end if
         else if (key = "back")
            if(m.markupGridSeasons.hasFocus())
                m.episodesBtn.setFocus(true)
                m._currentFocus = m.episodesBtn
                m.episodeGroup.visible = false
                handled = true
            end if
        end if
    end if
    return handled
end function

