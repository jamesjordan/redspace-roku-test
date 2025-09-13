function HomePageMediator() as Object
    if (m._HomePageMediatorSingleton = Invalid)
        prototype = EventDispatcher()

        '/// PRIVATE PROPERTIES
        '////////////////////////////
        prototype._container = Invalid
        prototype._view = Invalid

        '/// PUBLIC EVENTS
        '////////////////////////////
        prototype.CONTENT_ITEM_SELECTED = "HomePageMediator_CONTENT_ITEM_SELECTED"
        

        '/// PUBLIC API
        '////////////////////////////
        prototype.initContainer = sub(container as Object)
            print "HomePageMediator initContainer() container:"; container
            m._container = container
        end sub

        prototype.draw = sub()
            m._view = createObject("roSGNode", "HomePageView")
            m._view.observeField("selectedData", "HomePageMediator_onSelectedData")
            m._container.appendChild(m._view)
        end sub

        prototype.updateView = sub(rowData)
            m._view.rowData = rowData
        end sub

        prototype.setFocus = sub(val as boolean)
            m._view.setFocus(true)
        end sub

        prototype._destroyViews = sub() as void
            m._view.unobserveField("contentSelected")
            m._container.removeChild(m._view)
            m._container = invalid
            m._view = invalid
        end sub

        '/// PRIVATE METHODS
        '/////////////////////////////////
        prototype.onSelectedData = sub(data)
            m.dispatchEvent(m.CONTENT_ITEM_SELECTED, data)
        end sub


        m._HomePageMediatorSingleton = prototype

    end if
    return m._HomePageMediatorSingleton
  end function
  
sub DestroyHomePageMediator()
    print "HomePageMediator DestroyHomePageMediator():"
    m._HomePageMediatorSingleton._destroyViews()
    m._HomePageMediatorSingleton = Invalid
end sub

'/// PUBLIC LISTENERS METHODS
'/////////////////////////////////
sub HomePageMediator_onSelectedData(evt)
    data = evt.getData()
    m._HomePageMediatorSingleton.onSelectedData(data)
end sub
