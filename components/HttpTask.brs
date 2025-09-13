sub init()
  m.top.functionName = "load"
end sub

sub load()
  request = m.top.request
  requestUri = request.uri
  protocol = requestUri.tokenize(":")[0]

  if(protocol = "pkg")
    readLocalFile(requestUri)
  else if(protocol = "http")
    loadHttps(request)
  else if(protocol = "https")
    loadHttps(request)
  end if
end sub

sub readLocalFile(requestUri as String)
  fileStr = ReadASCIIFile(requestUri)

  response_obj = {}

    if (fileStr <> "")
      response_obj.data = ParseJson(fileStr)
      response_obj.code = 200
    else
      response_obj.code = 0
      response_obj.data = ""
    end if

    responseObjStr = FormatJson(response_obj)
    m.top.response = responseObjStr
  end sub

sub loadHttps(requestOb as object)
  timeout = 20000
  msgPort = CreateObject("roMessagePort")
  urlTransfer = CreateObject("roUrlTransfer")
  urlTransfer.setUrl(requestOb.uri)
  urlTransfer.setMessagePort(msgPort)
  urlTransfer.setCertificatesFile("common:/certs/ca-bundle.crt")
  urlTransfer.initClientCertificates()
  
  if(requestOb.headers <> invalid)
    for each item in requestOb.headers
      print item.name; ", "; item.value
      urlTransfer.AddHeader(item.name, item.value)
    end for
  end if

  if(requestOb.body = Invalid)
    urlTransfer.setRequest("GET")
    requestSuccess = urlTransfer.asyncGetToString()
  else 
    urlTransfer.setRequest("POST")
    requestSuccess = urlTransfer.AsyncPostFromString(requestOb.body)
  end if

  response = ""
  responseOb = {code:0, data:"No Response"}
  if (requestSuccess)
    response = msgPort.waitMessage(timeout)
  end if

  if (response <> Invalid)
    responseOb.code = response.GetResponseCode()
    responseOb.data = response.getString()
  end if

  responseOb.uid = m.top.id

  ' debugResponse(response, requestOb.uri, m.top.id)

  m.top.response = FormatJson(responseOb)
end sub

'@response: type = roUrlEvent
sub debugResponse(response, uri, uid)
  if(response <> invalid)
    code = response.GetResponseCode()
    reason = response.GetFailureReason()
    responseStr = response.GetString()
    
    print "HttpTask debugResponse uri:"; uri
    print "HttpTask debugResponse uid:"; uid
    print "HttpTask debugResponse code:"; code
    print "HttpTask debugResponse reason:"; reason
    ' print "HttpTask debugResponse responseStr:"; responseStr
  else 
    print "HttpTask debugResponse response INVALID:"
  end if
end sub
