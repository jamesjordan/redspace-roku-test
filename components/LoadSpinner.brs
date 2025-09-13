sub init () as Void
  spinner = m.top.findNode("spinner")
  spinner.poster.uri="pkg:/images/loading.png"
  spinner.poster.width = 170
  spinner.poster.height = 170
  m.spinner = spinner
end sub
