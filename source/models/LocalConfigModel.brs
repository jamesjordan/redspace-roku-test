function GetLocalConfigModel() as object
    if (m._localConfigModelSingleton = invalid)
        prototype = EventDispatcher()

        ' events

        ' dependencies

        ' private
        prototype._data = {}
        prototype.global = GetGlobalAA().global

        '////////////////////////////
        '/// PUBLIC API ///
        '////////////////////////////
        prototype.getData = function() as object
            return m.global.config
        end function

        '////////////////////////////////////////////////
        '/// PRIVATE PROPERTIES ///
        '////////////////////////////////////////////////
        prototype.init = function() as Object
			return m
		end function
        
        prototype._loadLocalConfigDataSuccessful = sub(request)
            m._removeEventListeners()
            m._data = ParseJSON(request.getData())
            m._loadLocalConfigTask.control = "DONE"
            m._loadLocalConfigTask = invalid
            m.dispatchEvent(m.LOCAL_CONFIG_DATA_RETRIEVED)
        end sub

        '////////////////////////////////////////////////
        '/// PRIVATE PROPERTIES ///
        '////////////////////////////////////////////////
        prototype._loadLocalConfigDataFailed = sub()
            m._removeEventListeners()
            m.dispatchEvent(m.LOCAL_CONFIG_DATA_RETRIEVED)
        end sub

        prototype._removeEventListeners = sub()
            m._loadLocalConfigTask.unobserveField("request_success")
        end sub

        prototype._destroy = sub()
            m._removeEventListeners()
        end sub

        m._localConfigModelSingleton = prototype

    end if
    return m._localConfigModelSingleton
end function

sub DestroyLocalConfigModel()
    if (m._localConfigModelSingleton <> invalid)
        m._localConfigModelSingleton._destroy()
        m._localConfigModelSingleton = invalid
    end if
end sub

sub LocalConfigModel_onLocalConfigDataSuccessful(r as dynamic) as void
    if (m._localConfigModelSingleton <> invalid)
        m._localConfigModelSingleton._loadLocalConfigDataSuccessful(r)
    end if
end sub
