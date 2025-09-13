function GetEpisodesService() as object

    prototype = BaseService()

    prototype.load = sub(showId as string) as void
        print "Episodes load:"
        
        request = {}

        request.uri = "https://api.tvmaze.com/shows/" + showId + "/episodes"

        m._load(request)
    end sub

	return prototype
end function
