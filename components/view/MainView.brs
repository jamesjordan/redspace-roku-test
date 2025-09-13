sub init ()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false
	if (press = true)
        if (key = "left")
            m.top.unhandledLeftPress = true
		else if (key = "back")
			m.top.unhandledBackPress = true
			handled = true
		end if
	end if
	return handled
end function
