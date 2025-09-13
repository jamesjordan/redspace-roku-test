sub init()
    'm.titleLbl = m.top.findNode("label")
    'm.top.observeField("pageName", "onPageName")

    m.top.observeField("focusedChild", "onFocus")
    m.top.observeField("pageData", "onPageData")

    m.video = m.top.findNode("exampleVideo")
end sub

sub onPageData()

    hlsNode = CreateObject("roSGNode", "ContentNode")
    hlsNode.url = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"

    dashNode = CreateObject("roSGNode", "ContentNode")
    dashNode.streamFormat = "dash"
    dashNode.url = "https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears.mpd"
    dashNode.drmParams = { 
        keySystem: "Widevine",
        licenseServerURL: "https://proxy.uat.widevine.com/proxy?provider=widevine_test"
    }

    contentNodes = [hlsNode, dashNode]
    randomContentNode = contentNodes[RND(2)-1]
    randomContentNode.title = m.top.pageData.name

    m.video.content = randomContentNode
    m.video.setFocus(true)
    m.video.control = "play"
end sub

sub onPageName()
    print "VideoView m.top.pageName:"; m.top.pageName
end sub

sub onFocus()
    if(m.top.hasFocus())
        print "VideoView has focus."
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if (press = true)
        if (key = "back")
        end if
    end if
    return handled
end function
