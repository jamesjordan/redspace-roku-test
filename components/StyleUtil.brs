function GetStyle(styleName as string) as object
    styleOb = m.global.styles[styleName]
    'typography = GetTypography(styleOb.typography)

    'TODO:Is there a quicker way to copy the object? Is this slow? 
    styleStr = FormatJson(styleOb)
    newStyle = ParseJson(styleStr)
    'newStyle.FONT = typography.font
    
    return newStyle
end function

function GetFont(styleName as string) as object
    return GetTypography(styleName).font
end function

function GetTypography(styleName as string) as object
    t = invalid
    if(m.global.typography <> invalid)
        t = m.global.typography[styleName]
    end if
    return t
end function

function GetColor(color as string) as string
    c = ""
    if(m.global.color <> invalid)
        c = m.global.color[color]
    end if
    return c
end function
