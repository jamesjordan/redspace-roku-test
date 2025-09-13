function GetVideoPageController() as object
    if (m._initVideoPageSingleton = invalid)
        prototype = AbstractController()

        ' models
        prototype._navigationModel = invalid
        prototype._contentModel = invalid

        ' commands

        ' mediators
        prototype._videoPageMediator = invalid
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
            m._videoPageMediator = VideoPageMediator()
        end sub

        prototype.registerCommands = sub()
        end sub

        prototype.init = sub ()
        end sub

        prototype.launch = sub(stateData as object)
            print ""
            print ""
            print ""
            print "VideoPageController().launch() stateData:"; stateData
            print "VideoPageController().launch() stateData.pageData:"; stateData.pageData
            m._videoPageMediator.initContainer(m._mainViewMediator.getView())
            m._videoPageMediator.draw(stateData.pageName)

            m._videoPageMediator.updateView(stateData.pageData)

            g = GetGlobalAA()
            g.global.loading = false
        end sub

        prototype.setFocus = sub(val as boolean)
            m._videoPageMediator.setFocus(true)
        end sub

        prototype.exit = sub ()
            DestroyVideoPageMediator()
        end sub


        prototype.destroy = sub ()
            m._videoPageMediator = invalid
            m._mainViewMediator = invalid
            DestroyVideoPageController()
        end sub

        '////////////////
        '/// PRIVATE  ///
        '////////////////

        m._initVideoPageSingleton = prototype
    end if

    return m._initVideoPageSingleton
end function

sub DestroyVideoPageController ()
    m._initVideoPageSingleton = invalid
end sub
