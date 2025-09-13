sub init()
    m.top.direction = "horizontal" ' Default direction
    m._focusIndex = 0 ' Initialize focus index
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if (not press) then return false

    focusableChildren = getFocusableChildren()
    if (focusableChildren.count() = 0) then return false

    direction = m.top.direction
    moved = false

    if (direction = "horizontal")
        if (key = "right")
            moved = moveFocus(1)
        else if (key = "left")
            moved = moveFocus(-1)
        end if
    else if (direction = "vertical")
        if (key = "down")
            moved = moveFocus(1)
        else if (key = "up")
            moved = moveFocus(-1)
        end if
    end if

    return moved
end function

function getFocusableChildren() as Object
    children = m.top.getChildren()
    focusable = []
    
    for each child in children
        if (child.focusable)
            focusable.push(child)
        end if
    next

    return focusable
end function

function moveFocus(s as Integer) as Boolean
    focusableChildren = getFocusableChildren()
    if (focusableChildren.count() = 0) then return false

    newIndex = m._focusIndex + s
    if (newIndex >= 0 and newIndex < focusableChildren.count())
        m._focusIndex = newIndex
        focusableChildren[newIndex].setFocus(true)
        return true
    end if
    
    return false
end function
