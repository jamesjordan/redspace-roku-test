function LocalConfigService() as object
    prototype = BaseService()
    prototype.load = sub() as void
        request = {}
        request.uri = "pkg:/data/config.json"
        m._load(request)
    end sub
	return prototype
end function
