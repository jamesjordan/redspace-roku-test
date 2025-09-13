sub init()
    m.top.observeField("focusedChild", "onFocus")
end sub

sub onPageName()
    print "EmptyPageView m.top.pageName:"; m.top.pageName
end sub

sub onFocus()
    if(m.top.hasFocus())
        print "EmptyPageView has focus."
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false
	if (press = true)
		if (key = "back")
		end if
	end if
	return handled
end function
  