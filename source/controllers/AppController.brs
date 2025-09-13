function GetAppController() as object
    if (m._appControllerSingleton = invalid)
        prototype = {}

        ' dependencies
        prototype._mainViewMediator = invalid
        prototype._navigationModel = invalid

        '////////////////////////////
        '/// PUBLIC API ///
        '////////////////////////////

        prototype.setRoots = sub(mainContainer, splashContainer, loadingSpinner)
            m._mainViewMediator = MainViewMediator()
            m._mainViewMediator.addEventListener(m._mainViewMediator.UNHANDLED_BACK_PRESS, "onMainViewUnhandledBackPress", m)
            m._mainViewMediator.initContainer(mainContainer)

            m.loadingSpinner = loadingSpinner
        end sub

        prototype.init = sub ()
            g = GetGlobalAA()
            g.global.observeField("loading", "onLoading")

            scene = g.top.getScene()
            scene.observeField("dialog", "onDialog")

            m._navigationModel = GetNavigationModel()
            m._navigationModel.addEventListener(m._navigationModel.NAVIGATION_CHANGED, "_navigationChangedHandler", m)
            m._navigationChangedHandler({ page: TemplateNames().INITIALIZE })
        end sub

        '////////////////////////////////////////////////
        '/// PRIVATE  ///
        '////////////////////////////////////////////////

        prototype._navigationChangedHandler = sub(navigationObject as object)
            page = LCase(navigationObject.page)

            if (m._stateController <> invalid)
                m._stateController.exit()
                m._stateController.destroy()
            end if

            print "AppController page:"; page

            if (page = LCase(TemplateNames().INITIALIZE))
                'TODO:AppController should probably create the side menu
                m._stateController = GetInitController()
            else if (page = LCase(TemplateNames().HOME))
                m._stateController = GetHomePageController()
            else if (page = LCase(TemplateNames().ITEM_DETAIL))
                m._stateController = GetDetailsPageController()
            else if (page = LCase(TemplateNames().VIDEO_PLAYER))
                m._stateController = GetVideoPageController()
            else
                m._stateController = EmptyPageController()
            end if

            m._stateController.setupModels()
            m._stateController.setupMediators()
            m._stateController.registerCommands()
            m._stateController.init()
            m._stateController.launch(navigationObject)
            m._stateController.setFocus(true)
        end sub

        prototype.onMainViewUnhandledLeftPress = sub()
            m._sideMenuViewMediator.setFocus(true)
        end sub

        prototype.onMainViewUnhandledBackPress = sub()
            handled = m._navigationModel.back()
            if (NOT handled)
                'TODO:Exit app. Show Dialog
            end if
        end sub

        prototype.setLoading = sub()
            m.loadingSpinner.visible = GetGlobalAA().global.loading
        end sub

        prototype.destroy = sub ()
            'destroy code goes here
        end sub

        prototype._stateController = invalid

        m._appControllerSingleton = prototype
    end if
    return m._appControllerSingleton
end function

sub DestroyAppController () as void
    m._appControllerSingleton = invalid
end sub

sub onLoading()
    m._appControllerSingleton.setLoading()
end sub

sub onDialog(evnt)
    scene = GetGlobalAA().top.getScene()
    if(scene.dialog <> Invalid)
        'Dialog is shown
    else 
        'Dialog has been closed
    end if
end sub
