sub init()
    m.top.functionName = "createStyles"
end sub

sub createStyles()
    stylesheet = m.global.stylesheet

    addColorsToGlobbal(stylesheet.colors)
    addTypographyToGlobbal(stylesheet.typography, stylesheet.fonts)
    addStylesToGlobbal(stylesheet.styles, stylesheet.colors)

    m.global.setFields({stylesheet:invalid})

    m.top.stylesComplete = true
end sub

sub addColorsToGlobbal(styles as object)
    colors = {}
    for each item in styles
        colors[item] = styles[item]
    end for
    m.global.addFields({colors:colors})
end sub

sub addStylesToGlobbal(styles as object, colors as object)
    stylesOb = {}
    for each item in styles
      s = styles[item]
      for each property in s
        if(Type(s[property]) = "roString" AND colors[s[property]] <> Invalid)
            s[property] = colors[s[property]]
        end if
      end for
      stylesOb[item] = s
    end for
    m.global.addFields({styles:stylesOb})
end sub

sub addTypographyToGlobbal(typography as object, fonts as object)
    typographyOb = {}
    for each item in typography
      s = {}
      t = typography[item]
      s.FONT = createFont(t.FONT_SIZE, fonts[t.FONT_NAME][t.FONT_WEIGHT])
      typographyOb[item] = s
    end for
    m.global.addFields({typography:typographyOb})
end sub

function createFont(fontSize as integer, uri as string) as object
    f = CreateObject("roSGNode", "Font")
    f.uri = uri
    f.size = fontSize
    return f
end function
