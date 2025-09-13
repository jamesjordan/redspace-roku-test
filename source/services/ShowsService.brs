function GetShowsService() as object

    prototype = BaseService()

    prototype.load = sub() as void
        print "ShowsService load:"

        request = {}

        request.uri = "https://api.tvmaze.com/shows"

        m._load(request)
    end sub

	return prototype
end function
