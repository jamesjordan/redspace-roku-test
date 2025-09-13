sub init()
    m.style = GetStyle("content-page")

    m.title = m.top.findNode("titleLbl")
    m.title.color = m.style.title_color
    m.title.font = GetFont(m.style.title_font)

    m.noContentLbl = m.top.findNode("noContent")
    m.noContentLbl.font = GetFont(m.style.nocontent_font)
    m.noContentLbl.color = m.style.nocontent_color
    m.noContentLbl.text = "No Content"

    m.markupGrid = m.top.findNode("markupGridList")
    m.markupGrid.observeField("itemFocused", "onGridItemFocused")
    m.markupGrid.observeField("itemSelected", "onGridItemSelected")
    m.markupGrid.observeField("navDir", "onGridDir")
    m.markupGrid.observeField("navBurst", "onNavBurst")

    m.top.observeField("rowData", "onRowData")
    m.top.observeField("focusedChild", "onFocus")

    m.transAnimationOff = m.top.FindNode("transAnimationOff")
    m.rotateAnimationOff = m.top.FindNode("rotateAnimationOff")
    m.transAnimationOn = m.top.FindNode("transAnimationOn")
    m.rotateAnimationOn = m.top.FindNode("rotateAnimationOn")

    m.titleAnim = m.top.FindNode("titleAnim")
    m.transInterp = m.top.findNode("titleTransInterp")
    m.rotInterp = m.top.findNode("titleRotInterp")
    m.posOn = [141, 100]
    m.rotOn = 0.0
    m.posOff = [-10, 100]
    m.rotOff = 1.57
    m.isOff = false

    m._currentFocus = invalid
end sub

sub onFocus()
    if(m.top.hasFocus())
        if(m._currentFocus <> invalid)
            m._currentFocus.setFocus(true)
        end if
    end if
end sub

sub onGridItemFocused()
    if(m.markupGrid.itemFocused < 7)
        AnimateOn()
    end if
end sub

sub onGridItemSelected()
    selected = m.markupGrid.itemSelected
    selectedContent = m.markupGrid.content.getChild(selected)
    m.top.selectedData = { content: selectedContent, index: selected }
end sub

sub AnimateOff()
    AnimateTitleTo(m.posOff, m.rotOff, true)
end sub

sub AnimateOn()
    AnimateTitleTo(m.posOn, m.rotOn, false)
end sub

sub onGridDir()
    dir = m.markupGrid.navDir
    if dir = "down" and m.markupGrid.itemFocused > 6
        AnimateOff()
    else if dir = "up" and m.markupGrid.itemFocused < 14
        AnimateOn()
    end if
end sub

sub onNavBurst()
    burst = m.markupGrid.navBurst
    if burst = "double" or burst = "hold" then
        AnimateOff()
    end if
end sub

sub createGrid(gridDataArray)
    m.markupGrid.content = invalid

    gridData = {}
    gridData.children = gridDataArray

    if(gridData <> invalid and gridData.children <> invalid)
        m.noContentLbl.visible = false

        m.markupGrid.numColumns = 7
        m.markupGrid.itemSize = [210, 295]
        m.markupGrid.itemSpacing = [24, 80]

        m.title.visible = true
        m.title.text = "Shows"
        m.markupGrid.translation = [141, 223]

        m.markupGridContent = createObject("roSGNode", "ContentNode")
        m.markupGridContent.Update({
            children: gridData.children
        }, true)

        m.markupGrid.content = m.markupGridContent
    else
        m.noContentLbl.visible = true
    end if
end sub

sub onRowData()
    rowsData = m.top.rowData
    createGrid(rowsData)
    m.markupGrid.setFocus(true)
    m._currentFocus = m.markupGrid
end sub


' --- Core, idempotent animator ---
sub AnimateTitleTo(posTarget as object, rotTarget as float, offState as boolean)
    ' If a previous delayed run was queued, stopping first is a safe no-op
    m.titleAnim.control = "stop"

    curPos = m.title.translation
    curRot = m.title.rotation

    if IsVecClose(curPos, posTarget) and IsFloatClose(curRot, rotTarget)
        m.isOff = offState : return
    end if

    ' keys from CURRENT -> target (no jump)
    m.transInterp.keyValue = [curPos, posTarget]
    m.rotInterp.keyValue = [curRot, rotTarget]

    ' duration tweak (optional)
    d = Sqr((curPos[0] - posTarget[0]) * (curPos[0] - posTarget[0]) + (curPos[1] - posTarget[1]) * (curPos[1] - posTarget[1])) + Abs(curRot - rotTarget) * 80
    m.titleAnim.duration = Clamp(0.12 + d / 1200.0, 0.12, 0.28)

    ' <<< key bit: delay only when animating ON >>>
    if offState then
        m.titleAnim.delay = 0.0
    else
        m.titleAnim.delay = .08 ' ~80ms feels good; tune as needed
    end if

    m.titleAnim.control = "start"
    m.isOff = offState
end sub

' --- Utility ---
function IsVecClose(a as object, b as object) as boolean
    return Abs(a[0] - b[0]) < 0.5 and Abs(a[1] - b[1]) < 0.5
end function

function IsFloatClose(a as float, b as float) as boolean
    return Abs(a - b) < 0.01
end function

function Clamp(v as float, lo as float, hi as float) as float
    if v < lo then return lo
    if v > hi then return hi
    return v
end function