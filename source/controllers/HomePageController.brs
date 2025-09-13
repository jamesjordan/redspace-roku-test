function GetHomePageController() as object
	if (m._initHomePageSingleton = invalid)
		prototype = AbstractController()

		' models
		prototype._contentModel = invalid
		prototype._navigationModel = invalid

		' commands

		' mediators
		prototype._homePageMediator = invalid
		prototype._mainViewMediator = invalid

		' tasks

		'//////////////////
		'/// PUBLIC API ///
		'//////////////////

		prototype.setupModels = sub()
			m._contentModel = GetContentModel()
			m._navigationModel = GetNavigationModel()
		end sub

		prototype.setupMediators = sub()
			m._mainViewMediator = MainViewMediator()
			m._homePageMediator = HomePageMediator()
			m._homePageMediator.addEventListener(m._homePageMediator.CONTENT_ITEM_SELECTED, "onContentItemSelected", m)
		end sub

		prototype.registerCommands = sub()
		end sub

		prototype.init = sub ()
		end sub

		prototype.launch = sub(stateData as object)
			m.stateData = stateData
			m._homePageMediator.initContainer(m._mainViewMediator.getView())
			m._homePageMediator.draw()

			g = GetGlobalAA()
			g.global.loading = true

			m._contentModel.addEventListener(m._contentModel.HOME_CONTENT_LOADED_SUCCESS, "onShowsLoaded", m)
			m._contentModel.addEventListener(m._contentModel.HOME_CONTENT_LOADED_FAILED, "onShowsFailed", m)
			m._contentModel.requestHomePageData()
		end sub

		prototype.onContentItemSelected = sub(selectedData)
			selectedContentNode = selectedData.content
			ob = {}
			ob.pageData = selectedData
			m._navigationModel.changeTemplate(TemplateNames().ITEM_DETAIL, ob)
		end sub

		prototype.setFocus = sub(val as boolean)
			m._homePageMediator.setFocus(true)
		end sub

		prototype.exit = sub ()
			m._homePageMediator.removeEventListener(m._homePageMediator.CONTENT_ITEM_SELECTED, "onContentItemSelected", m)
			m._contentModel.removeEventListener(m._contentModel.HOME_CONTENT_LOADED_SUCCESS, "onShowsLoaded", m)
			m._contentModel.removeEventListener(m._contentModel.HOME_CONTENT_LOADED_FAILED, "onShowsFailed", m)
			DestroyHomePageMediator()
		end sub

		prototype.destroy = sub ()
			print "HomePageController destroy():"
			m._contentModel = invalid
			m._navigationModel = invalid
			m._homePageMediator = invalid
			m._mainViewMediator = invalid
			DestroyHomePageController()
		end sub

		'////////////////
		'/// PRIVATE  ///
		'////////////////
		prototype.onShowsLoaded = sub(response)
			g = GetGlobalAA()
			g.global.loading = false
			m._homePageMediator.updateView(response)
		end sub

		prototype.onShowsFailed = sub()
			g = GetGlobalAA()
			g.global.loading = false
			m._homePageMediator.updateView({})
		end sub

		m._initHomePageSingleton = prototype
	end if

	return m._initHomePageSingleton
end function

sub DestroyHomePageController ()
	m._initHomePageSingleton = invalid
end sub
