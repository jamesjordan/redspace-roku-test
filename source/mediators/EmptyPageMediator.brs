function EmptyPageMediator() as object
    if (m._emptyPageMediatorSingleton = invalid)
        prototype = EventDispatcher()

        '/// PRIVATE PROPERTIES
        '////////////////////////////
        prototype._container = invalid

        '/// PUBLIC EVENTS
        '////////////////////////////


        '/// PUBLIC API
        '////////////////////////////
        prototype.initContainer = sub(container as object)
            m._container = container
        end sub

        prototype.draw = sub(pageName)
            m._view = createObject("roSGNode", "EmptyPageView")
            m._view.pageName = pageName
            m._container.appendChild(m._view)
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

        m._emptyPageMediatorSingleton = prototype

    end if
    return m._emptyPageMediatorSingleton
end function

sub DestroyEmptyPageMediator()
    m._emptyPageMediatorSingleton._destroyViews()
    m._emptyPageMediatorSingleton = invalid
end sub

'/// PUBLIC LISTENERS METHODS
'/////////////////////////////////

