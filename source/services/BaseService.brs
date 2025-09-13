function BaseService() as object

    prototype = EventDispatcher()

    prototype.LOAD_SUCCESS = "BaseService.LOAD_SUCCESS"
    prototype.LOAD_FAILED = "BaseService.LOAD_FAILED"

    prototype.id = invalid
    prototype.request = invalid

    prototype._load = function(request as object) as dynamic

        di = CreateObject("roDeviceInfo")
        uniqueID = di.GetRandomUUID()

        if(request.type <> invalid AND request.type = "POST")
            request.body = request.body
        else
            if(request.body <> invalid)
                request.body = prepareBody(request.body)
            end if
        end if

        m.id = uniqueID
        m.request = request
        saveRequest(uniqueID, m)

        processLoadQue()

        return uniqueID
    end function

    prototype.doLoad = sub()
        uniqueID = m.id
        request = m.request

        m._loadNavTask = createObject("roSGNode", "HttpTask")
        m._loadNavTask.id = uniqueID
        m._loadNavTask.request = request
        m._loadNavTask.observeField("response", "BaseService_onRequestData")
        m._loadNavTask.observeField("state", "BaseService_stateChanged")
        m._loadNavTask.control = "RUN"
    end sub

    prototype.httpRequestCompleteHandler = sub(evt)
        ' print "BaseService httpRequestCompleteHandler():"; m.id
        m._loadNavTask.unObserveField("response")
        m._loadNavTask.unObserveField("state")
        m._loadNavTask.control = "DONE"
        m._loadNavTask = Invalid
        
        data = ParseJson(evt.getData())
        data.uid = m.id
        code = data.code
        if(code >= 200 AND code < 300)
            m.dispatchEvent(m.LOAD_SUCCESS, data)
        else 
            m.dispatchEvent(m.LOAD_FAILED, data)
        end if
    end sub

	return prototype
end function

sub processLoadQue()
    loadQueLength = m._loadQue.count() 
    curLoads = m.currentLoads

    if(loadQueLength = 0)
        print "BaseService nothing in the que"
        return
    else if(curLoads >= m.maxLoad)
        print "BaseService load que is full"
        return
    else if(loadQueLength < m.maxLoad - curLoads)
        numItems = loadQueLength
    else 
        numItems = m.maxLoad - curLoads
    end if
    
    for i = 0 to numItems - 1
        m.currentLoads += 1
        request = lookupRequest(m._loadQue[0])
        request.doLoad()
        m._loadQue.Shift()
    end for
end sub

sub saveRequest(id, request) as void
    if(m._requests = invalid)
        m.maxLoad = 20
        m.currentLoads = 0
        m._requests = {}
        m._loadQue = []
    end if
    m._requests.addReplace(id, request)

    m._loadQue.push(id)
end sub

sub removeRequest(id) as void
    m._requests.delete(id)
end sub

function lookupRequest(id as string) as object
    return m._requests.lookup(id)
end function

sub BaseService_onRequestData(evt as Object) as void
    taskId = evt.getNode()
    savedRequest = lookupRequest(taskId)
    savedRequest.httpRequestCompleteHandler(evt)
    removeRequest(taskId)
    m.currentLoads -= 1
    processLoadQue()
end sub

function prepareBody(loginParams) as string
    print "BaseService prepareBody loginParams:"; loginParams
    body = ""
    loginParts = []
    for each loginParam in loginParams
        trimmedPart = loginParam.value.EncodeUriComponent()
        loginParts.push(loginParam.key + "=" + trimmedPart)
    end for

    if (loginParts.count() > 0)
        body += loginParts.join("&")
    end if

    return body
end function
