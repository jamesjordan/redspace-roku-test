function DetailsPageMediator() as Object
    if (m._DetailsPageMediatorSingleton = Invalid)
        prototype = EventDispatcher()

        '/// PRIVATE PROPERTIES
        '////////////////////////////
        prototype._container = Invalid
        prototype._view = Invalid

        '/// PUBLIC EVENTS
        '////////////////////////////
        prototype.WATCH_NOW_SELECTED = "DetailsPageMediator.WATCH_NOW_SELECTED"

        '/// PUBLIC API
        '////////////////////////////
        prototype.initContainer = sub(container as Object)
            print "DetailsPageMediator initContainer() container:"; container
            m._container = container
        end sub

        prototype.draw = sub()
            m._view = createObject("roSGNode", "DetailsPage")
            m._view.observeField("watchNow", "DetailsPageMediator_onWatchNow")
            print "DetailsPageMediator draw() m._view:"; m._view
            m._container.appendChild(m._view)
        end sub

        prototype.updateView = sub(pageData)
            print "DetailsPageMediator updateView() pageData:"; pageData
            m._view.pageData = pageData
        end sub

        prototype.updateEpisodes = sub(episodeData)
            print "DetailsPageMediator updateEpisodes() episodeData:"; episodeData
            m._view.episodeData = episodeData
        end sub

        prototype.updateSeriesPageData = sub(seriesData)
            print "DetailsPageMediator updateSeriesData() seriesData:"; seriesData
            m._view.seriesPageData = seriesData
        end sub

        prototype.setFocus = sub(val as boolean)
            m._view.setFocus(true)
        end sub

        prototype.onWatchNow = function(data)
            print "DetailsPageMediator onWatchNow data:"; data
            m.dispatchEvent(m.WATCH_NOW_SELECTED, data)
        end function

        prototype._destroyViews = sub() as void
            print "DetailsPageMediator _destroyViews:"
            m._view.unobserveField("watchNow")
            m._container.removeChild(m._view)
            m._container = invalid
            m._view = invalid
        end sub

        m._DetailsPageMediatorSingleton = prototype
    end if
    return m._DetailsPageMediatorSingleton
end function

sub DestroyDetailsPageMediator()
    print "DetailsPageMediator DestroyDetailsPageMediator():"
    m._DetailsPageMediatorSingleton._destroyViews()
    m._DetailsPageMediatorSingleton = Invalid
end sub

sub DetailsPageMediator_onWatchNow(evt)
    data = evt.getData()
    m._DetailsPageMediatorSingleton.onWatchNow(data)
end sub
