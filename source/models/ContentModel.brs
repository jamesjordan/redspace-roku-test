function GetContentModel() as object

    if (m._contentModelSingleton = invalid)

        prototype = EventDispatcher()

        ' events
        prototype.HOME_CONTENT_LOADED_SUCCESS = "ContentModel.HOME_CONTENT_LOADED_SUCCESS"
        prototype.HOME_CONTENT_LOADED_FAILED = "ContentModel.HOME_CONTENT_LOADED_FAILED"
        prototype.SHOW_DATA_LOADED_SUCCESS = "ContentModel.SHOW_DATA_LOADED_SUCCESS"
        prototype.SHOW_DATA_LOADED_FAILED = "ContentModel.SHOW_DATA_LOADED_FAILED"
        prototype.EPISODES_DATA_LOADED_SUCCESS = "ContentModel.EPISODES_DATA_LOADED_SUCCESS"
        prototype.EPISODES_DATA_LOADED_FAILED = "ContentModel.EPISODES_DATA_LOADED_FAILED"

        prototype.showsService = invalid
        prototype.showService = invalid


        '////////////////////////////
        '/// PUBLIC API ///
        '////////////////////////////
        prototype.requestHomePageData = sub()
            print "ContentModel requestHomePageData:"
            m.showsService = GetShowsService()
            m.showsService.addEventListener(m.showsService.LOAD_SUCCESS, "_onRequestShowsDataSuccess", m)
            m.showsService.addEventListener(m.showsService.LOAD_FAILED, "_onRequestShowsDataFailed", m)
            m.showsService.load()
        end sub

        prototype.requestShowData = sub(showId as string)
            print "ContentModel requestShowData:"
            m.showService = GetShowService()
            m.showService.addEventListener(m.showService.LOAD_SUCCESS, "_onRequestShowDataSuccess", m)
            m.showService.addEventListener(m.showService.LOAD_FAILED, "_onRequestShowDataFailed", m)
            m.showService.load(showId)
        end sub

        prototype.requestEpisodesData = sub(showId as integer)
            print "ContentModel requestEpisodesData:"
            m.episodesService = GetEpisodesService()
            m.episodesService.addEventListener(m.showService.LOAD_SUCCESS, "_onRequestEpisodesDataSuccess", m)
            m.episodesService.addEventListener(m.showService.LOAD_FAILED, "_onRequestEpisodesDataFailed", m)
            m.episodesService.load(Str(showId).Trim())
        end sub

        '////////////////////////////////////////////////
        '/// PRIVATE PROPERTIES ///
        '////////////////////////////////////////////////
        prototype.init = function() as object
            return m
        end function

        prototype._onRequestShowsDataSuccess = sub(request)
            print "ContentModel _onRequestShowsDataSuccess:"
            m._removeEventListeners()
            response = ParseJSON(request.data)
            m.dispatchEvent(m.HOME_CONTENT_LOADED_SUCCESS, response)
        end sub

        prototype._onRequestShowsDataFailed = sub(request)
            print "ContentModel _onRequestShowsDataFailed:"
            m.dispatchEvent(m.HOME_CONTENT_LOADED_FAILED)
        end sub

        prototype._onRequestShowDataSuccess = sub(request)
            m._removeEventListeners()
            response = ParseJSON(request.data)
            m.dispatchEvent(m.SHOW_DATA_LOADED_SUCCESS, response)
        end sub

        prototype._onRequestShowDataFailed = sub(request)
            m.dispatchEvent(m.SHOW_DATA_LOADED_FAILED)
        end sub

        prototype._onRequestEpisodesDataSuccess = sub(request)
            print "ContentModel _onRequestEpisodesDataSuccess:"
            m._removeEventListeners()
            response = ParseJSON(request.data)
            idx = m.BuildSeasonIndex(response)
            m.dispatchEvent(m.EPISODES_DATA_LOADED_SUCCESS, idx)
        end sub

        prototype._onRequestEpisodesDataFailed = sub(request)
            print "ContentModel _onRequestEpisodesDataFailed:"
            m.dispatchEvent(m.EPISODES_DATA_LOADED_FAILED)
        end sub

        ' Returns: { seasons: [{ id: 1 }, { id: 2 }, ...], episodes: { "1": [...], "2": [...] } }
        prototype.BuildSeasonIndex = function(allEpisodes as object) as object
            result = { seasons: [], episodes: {} }
            seenSeasons = {} ' set of season keys we've already added

            if allEpisodes = invalid then return result

            for each ep in allEpisodes
                if ep <> invalid and ep.season <> invalid then
                    s = ep.season
                    key = Str(s).Trim() 

                    ' init bucket
                    if not result.episodes.doesexist(key)
                        result.episodes[key] = []
                    end if

                    ' append full episode object (preserves all fields)
                    result.episodes[key].push(ep)

                    ' add season header once
                    if not seenSeasons.doesexist(key)
                        result.seasons.push({ id: s })
                        seenSeasons[key] = true
                    end if
                end if
            end for

            return result
        end function



        prototype._removeEventListeners = sub()
        end sub

        m._contentModelSingleton = prototype.init()
    end if

    return m._contentModelSingleton
end function
