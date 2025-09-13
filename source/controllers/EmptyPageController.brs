function EmptyPageController() as Object
  if (m._initEmptyPageSingleton = Invalid)
    prototype = AbstractController()

    ' models

    ' commands

    ' mediators
    prototype._emptyPageMediator = invalid
    prototype._mainViewMediator = invalid

    ' tasks

    '//////////////////
    '/// PUBLIC API ///
    '//////////////////

    prototype.setupModels = sub()
    end sub

    prototype.setupMediators = sub()
      m._emptyPageMediator = EmptyPageMediator()
      m._mainViewMediator = MainViewMediator()
    end sub

    prototype.registerCommands = sub()
    end sub

    prototype.init = sub ()
    end sub

    prototype.launch = sub(stateData as Object)
      print ""
      print ""
      print ""
      print "EmptyPageController().launch() stateData:"; stateData
      m._emptyPageMediator.initContainer(m._mainViewMediator.getView())
      m._emptyPageMediator.draw(stateData.pageName)

      g = GetGlobalAA()
      g.global.loading = false
    end sub

    prototype.setFocus = sub(val as boolean)
      m._emptyPageMediator.setFocus(true)
    end sub

    prototype.exit = sub ()
      DestroyEmptyPageMediator()
  end sub


    prototype.destroy = sub ()
      m._emptyPageMediator = Invalid
      m._mainViewMediator = Invalid
        DestroyEmptyPageController()
    end sub

    '////////////////
    '/// PRIVATE  ///
    '////////////////

    m._initEmptyPageSingleton = prototype
  end if

  return m._initEmptyPageSingleton
end function

sub DestroyEmptyPageController ()
  m._initEmptyPageSingleton = Invalid
end sub
