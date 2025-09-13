sub init()
      m.clock = CreateObject("roTimespan") : m.clock.Mark()
      m.lastDownMs = -100000
      m.downHeld   = false

      m.hold = m.top.findNode("holdTimer")
      m.hold.observeField("fire", "onHoldFire")
    end sub

    sub onHoldFire()
      if m.downHeld then
        m.top.navDir   = "down"
        m.top.navBurst = "hold"   ' parent can AnimateOff() on this
      end if
    end sub

    function onKeyEvent(key as string, press as boolean) as boolean
      if press then
        if key = "down" then
          now = m.clock.TotalMilliseconds()
          delta = now - m.lastDownMs

          ' direction (for your existing logic)
          m.top.navDir = "down"

          ' double tap if within 400ms (tune)
          if delta >= 0 and delta < 400 then
            m.top.navBurst = "double"
          else
            m.top.navBurst = ""      ' clear
          end if

          ' start (or restart) hold timer
          m.hold.control = "stop"
          m.hold.duration = 0.18     ' tune: 0.12–0.20 usually feels right
          m.hold.control = "start"
          m.downHeld = true

          m.lastDownMs = now
        else if key = "up" then
          m.top.navDir = "up"
          ' Optional: mirror double/hold for up if you want
        end if
      else
        ' key up: cancel hold
        if key = "down" then
          m.hold.control = "stop"
          m.downHeld = false
        end if
      end if

      return false  ' let the grid keep handling navigation
    end function