sub Main()
  showChannelSGScreen()
end sub

sub showChannelSGScreen()
  screen = CreateObject("roSGScreen")

  di = createObject("roDeviceInfo")
  styles = getStyleSheet()
  uiResolution = di.GetUIResolution()

  print "main styles:"; styles

  m.global = screen.getGlobalNode()
  m.global.id = "GlobalNode"
  m.global.addFields({
    stylesheet: styles,
    loading:true,
    uiResolution: uiResolution
  })
  
  print "main m.global.stylesheet:"; m.global.stylesheet

  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  scene = screen.createScene("MainScene")
  scene.backgroundColor = "0x01202AFF"
  ' scene.backgroundURI = "pkg:/images/background.png"
  scene.backgroundURI = ""
  screen.show()
  ' vscode_rdb_on_device_component_entry
  scene.observeField("exitApp", m.port)

  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)
    print "main msgType:"; msgType
    if (msgType = "roSGScreenEvent")
      if (msg.isScreenClosed())
        return
      end if
    else if (msgType = "roSGNodeEvent")
      field = msg.getField()
      if (field = "exitApp")
        return
      end if
    end if
  end while
end sub

function getLocalJsonFile(uri) as object
  json = readAsciiFile(uri)
  ob = parseJSON(json)
  return ob
end function

function getStyleSheet() as object
  return getLocalJsonFile("pkg:/data/stylesheet.json")
end function
