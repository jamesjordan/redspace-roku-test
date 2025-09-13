function MainViewMediator() as Object
    if (m._MainViewMediatorSingleton = Invalid)
        prototype = EventDispatcher()

        '/// PRIVATE PROPERTIES
        '////////////////////////////
        prototype._container = Invalid

        '/// PUBLIC EVENTS
        '////////////////////////////
        prototype.UNHANDLED_LEFT_PRESS = "MainViewMediator_UNHANDLED_LEFT_PRESS"
        prototype.UNHANDLED_BACK_PRESS = "MainViewMediator_UNHANDLED_BCAK_PRESS"
        

        '/// PUBLIC API
        '////////////////////////////
        prototype.initContainer = sub (container as Object)
            m._container = container
            m._container.observeField("unhandledLeftPress", "MainViewMediator_onUnhandledLeftPress")
            m._container.observeField("unhandledBackPress", "MainViewMediator_onUnhandledBackPress")
        end sub

        prototype.getView = function()
            return m._container
        end function

        prototype._destroyViews = sub () as void
            m._container.unobserveField("unhandledLeftPress")
            m._container.unobserveField("unhandledBackPress")
            m._container = Invalid
        end sub

        '/// PRIVATE METHODS
        '/////////////////////////////////


        m._MainViewMediatorSingleton = prototype

    end if
    return m._MainViewMediatorSingleton
  end function
  
sub DestroyMainViewMediator()
    m._MainViewMediatorSingleton._destroyViews()
    m._MainViewMediatorSingleton = Invalid
end sub

sub MainViewMediator_onUnhandledLeftPress()
    m._MainViewMediatorSingleton.dispatchEvent(m._MainViewMediatorSingleton.UNHANDLED_LEFT_PRESS)
end sub

sub MainViewMediator_onUnhandledBackPress()
    m._MainViewMediatorSingleton.dispatchEvent(m._MainViewMediatorSingleton.UNHANDLED_BACK_PRESS)
end sub

'/// PUBLIC LISTENERS METHODS
'/////////////////////////////////

