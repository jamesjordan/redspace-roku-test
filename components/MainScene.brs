sub init()
  m.top.setFocus(true)

  m.appController = GetAppController()
  m.appController.setRoots(m.top.findNode("MainViewContainer"), m.top.findNode("SplashContainer"), m.top.findNode("Loader"))
  m.appController.init()
end sub
