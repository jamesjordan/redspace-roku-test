function AbstractController() as Object

  prototype = {}

  prototype.init = sub()
  end sub

  prototype.launch = sub(stateData as Object)
  end sub

  prototype.exit = sub()
  end sub

  prototype.destroy = sub()
  end sub

  prototype.setFocus = sub(val as boolean)
  end sub
  
  prototype.setupModels = sub() as void
  end sub

  prototype.registerCommands = sub() as void
  end sub

  prototype.setupMediators = sub() as void
  end sub

  return prototype
end function
