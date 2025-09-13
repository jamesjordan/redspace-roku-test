function GetNavigationModel() as object

	if (m._navigationModelSingleton = Invalid)

		prototype = EventDispatcher()

		 ' events
		prototype.NAVIGATION_CHANGED = "NavigationModel.NAVIGATION_CHANGED"

		prototype.currentNavLocation = invalid

		prototype._data = invalid
		prototype._history = []

		'////////////////////////////
        '/// PUBLIC API ///
        '////////////////////////////
		prototype.changeTemplate = sub(page as String, currentPageSettings = Invalid)
            foundPage = false
			if(page = TemplateNames().ITEM_DETAIL)
				foundPage = true
			else if(page = TemplateNames().VIDEO_PLAYER)
				foundPage = true
			else if(page = TemplateNames().HOME)
				foundPage = true
			end if

            if(foundPage)
                ob = {id:page, page:page, pageName:page}
                if(currentPageSettings <> Invalid AND currentPageSettings.pageData <> Invalid)
                    ob.pageData = currentPageSettings.pageData
                end if 
                m.updateNavigationLocation(ob, currentPageSettings)
            else 
                print "NavigationModel: Page Not found. Handle gracefully"
            end if
		end sub

		prototype.getNavigation = function()
			return m._data
		end function

		prototype.back = function() as boolean
			handled = false
			if(m._history.count() > 1)
				backLocation = m._history[m._history.Count() - 2]
				m._history.pop()
				m.dispatchEvent(m.NAVIGATION_CHANGED, backLocation)
				handled = true
			end if
			return handled
		end function

        '////////////////////////////////////////////////
        '/// PRIVATE PROPERTIES ///
        '////////////////////////////////////////////////
        prototype.init = function() as Object
			return m
		end function

		prototype.updateNavigationLocation = sub(navObject as object, currentPageSettings = Invalid as Object )
			if(currentPageSettings <> Invalid)
				m._history[m._history.Count() - 1].pageSettings = currentPageSettings
			end if
			m._history.push(navObject)
			m.currentNavLocation = navObject
			m.dispatchEvent(m.NAVIGATION_CHANGED, navObject)
		end sub

		prototype._removeEventListeners = sub()
		end sub	

		m._navigationModelSingleton = prototype.init()
	end if

	return m._navigationModelSingleton
end function
