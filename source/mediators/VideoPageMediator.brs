function VideoPageMediator() as object
    if (m._videoPageMediatorSingleton = invalid)
        prototype = EventDispatcher()

        '/// PRIVATE PROPERTIES
        '////////////////////////////
        prototype._container = invalid
        prototype._view = invalid

        '/// PUBLIC EVENTS
        '////////////////////////////


        '/// PUBLIC API
        '////////////////////////////
        prototype.initContainer = sub(container as object)
            m._container = container
        end sub

        prototype.draw = sub(pageName)
            m._view = createObject("roSGNode", "VideoPageView")
            m._container.appendChild(m._view)
        end sub

        prototype.updateView = sub(pageData)
            m._view.pageData = pageData
        end sub

        prototype.setFocus = sub(val as boolean)
            m._view.setFocus(true)
        end sub

        prototype._destroyViews = sub() as Void
            m._container.removeChild(m._view)
            m._container = invalid
            m._view = invalid
        end sub

        '/// PRIVATE METHODS
        '/////////////////////////////////

        m._videoPageMediatorSingleton = prototype

    end if
    return m._videoPageMediatorSingleton
end function

sub DestroyVideoPageMediator()
    m._videoPageMediatorSingleton._destroyViews()
    m._videoPageMediatorSingleton = invalid
end sub

'/// PUBLIC LISTENERS METHODS
'/////////////////////////////////

