function GetDetailsPageController() as object
    if (m._initDetailsPageSingleton = invalid)
        prototype = AbstractController()

        ' models
        prototype._navigationModel = invalid
        prototype._contentModel = invalid

        ' mediators
        prototype._mainViewMediator = invalid
        prototype._detailsPageMediator = invalid

        '//////////////////
        '/// PUBLIC API ///
        '//////////////////

        prototype.setupModels = sub()
            m._contentModel = GetContentModel()
            m._navigationModel = GetNavigationModel()
        end sub

        prototype.setupMediators = sub()
            m._mainViewMediator = MainViewMediator()
            m._detailsPageMediator = DetailsPageMediator()
            m._detailsPageMediator.addEventListener(m._detailsPageMediator.WATCH_NOW_SELECTED, "onWatchNowSelected", m)
        end sub

        prototype.registerCommands = sub()
        end sub

        prototype.init = sub()
        end sub

        prototype.launch = sub(stateData as object)
            print "DetailsPageController launch() stateData:"; stateData
            print "DetailsPageController launch() stateData.pageData:"; stateData.pageData
            m.stateData = stateData
            m._detailsPageMediator.initContainer(m._mainViewMediator.getView())
            m._detailsPageMediator.draw()

            g = GetGlobalAA()
            g.global.loading = true

            m._contentModel.addEventListener(m._contentModel.SHOW_DATA_LOADED_SUCCESS, "onShowLoaded", m)
			m._contentModel.addEventListener(m._contentModel.SHOW_DATA_LOADED_FAILED, "onShowFailed", m)
			m._contentModel.requestShowData(stateData.pageData.content.id)
        end sub

        prototype.setFocus = sub(val as boolean)
            m._detailsPageMediator.setFocus(true)
        end sub

        prototype.exit = sub()
            m._detailsPageMediator.removeEventListener(m._detailsPageMediator.WATCH_NOW_SELECTED, "onWatchNowSelected", m)
            m._contentModel.removeEventListener(m._contentModel.SHOW_DATA_LOADED_SUCCESS, "onShowLoaded", m)
			m._contentModel.removeEventListener(m._contentModel.SHOW_DATA_LOADED_FAILED, "onShowFailed", m)
            m._contentModel.removeEventListener(m._contentModel.EPISODES_DATA_LOADED_SUCCESS, "onEpisodesLoaded", m)
			m._contentModel.removeEventListener(m._contentModel.EPISODES_DATA_LOADED_FAILED, "onEpisodesFailed", m)

            DestroyDetailsPageMediator()

            m._navigationModel = invalid
            m._contentModel = invalid
            m._mainViewMediator = invalid
            m._detailsPageMediator = invalid
        end sub

        prototype.destroy = sub()
            print "DetailsPageController destroy():"
            DestroyDetailsPageController()
        end sub

        '////////////////
		'/// PRIVATE  ///
		'////////////////
        prototype.onWatchNowSelected = function(watchItemData)
            ob = {}
			ob.pageData = watchItemData
            m._navigationModel.changeTemplate(TemplateNames().VIDEO_PLAYER, ob)
        end function

		prototype.onShowLoaded = sub(response)
			print "DetailsPageController onShowLoaded() response:"; response
			g = GetGlobalAA()
			g.global.loading = false
			m._detailsPageMediator.updateView(response)

            ' load episodes for the current show
            m._contentModel.addEventListener(m._contentModel.EPISODES_DATA_LOADED_SUCCESS, "onEpisodesLoaded", m)
			m._contentModel.addEventListener(m._contentModel.EPISODES_DATA_LOADED_FAILED, "onEpisodesFailed", m)
			m._contentModel.requestEpisodesData(response.id)
		end sub

		prototype.onShowFailed = sub()
			g = GetGlobalAA()
			g.global.loading = false
			m._detailsPageMediator.updateView({})
		end sub

        prototype.onEpisodesLoaded = sub(response)
			g = GetGlobalAA()
			g.global.loading = false
			m._detailsPageMediator.updateEpisodes(response)
		end sub

		prototype.onEpisodesFailed = sub()
			g = GetGlobalAA()
			g.global.loading = false
			m._detailsPageMediator.updateEpisdoes({})
		end sub

        m._initDetailsPageSingleton = prototype
    end if

    return m._initDetailsPageSingleton
end function

sub DestroyDetailsPageController()
    m._initDetailsPageSingleton = invalid
end sub
