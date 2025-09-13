function GetInitController() as Object
  if (m._initControllerSingleton = Invalid)
    prototype = AbstractController()
    prototype.global = GetGlobalAA().global
    prototype.styleTask = invalid

    ' models
    m._navigationModel = invalid

    ' commands

    ' mediators

    ' tasks

    '//////////////////
    '/// PUBLIC API ///
    '//////////////////

    prototype.setupModels = sub()
      m._navigationModel = GetNavigationModel()
    end sub

    prototype.setupMediators = sub()
    end sub

    prototype.init = sub()
      ' 
    end sub

    prototype.launch = sub(stateData as Object)
      'Debugging
      'm._loginModel._signOut()
      m.createStyleManager()
    end sub

    prototype.destroy = sub()
      m._navigationModel = invalid
      m._sideMenuMediator = invalid
      m._removeStyleTaskObservers()
      m.styleTask = invalid
      DestroyInitController()
    end sub

    '////////////////
    '/// PRIVATE  ///
    '////////////////
    prototype.createStyleManager = sub()
      m.styleTask = CreateObject("rosgnode", "StyleManagertask")
      m.styleTask.observeField("stylesComplete", "InitController_onStylesComplete")
      m.styleTask.observeField("state", "InitController_onState")
      m.styleTask.control = "RUN"
    end sub

    prototype._initCompleted = sub()
      m._navigationModel.changeTemplate(TemplateNames().HOME)
    end sub

    prototype._removeStyleTaskObservers = sub()
      m.styleTask.unObserveField("stylesComplete")
      m.styleTask.control = "DONE"
    end sub

    m._initControllerSingleton = prototype
  end if

  return m._initControllerSingleton
end function

sub DestroyInitController()
  m._initControllerSingleton = Invalid
end sub

sub InitController_onStylesComplete()
  m._initControllerSingleton._initCompleted()
end sub
