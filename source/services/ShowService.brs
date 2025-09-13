function GetShowService() as object

    prototype = BaseService()

    prototype.load = sub(showId as string) as void
        print "ShowService load:"

        request = {}

        request.uri = "https://api.tvmaze.com/shows/" + showId

        m._load(request)
    end sub

	return prototype
end function
