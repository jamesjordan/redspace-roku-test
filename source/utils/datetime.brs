function FormatDateTime(dateTime as object, format as string) as string
  hour = dateTime.getHours()
  minute = dateTime.getMinutes()
  day = dateTime.getDayOfMonth()
  month = dateTime.getMonth()
  year = dateTime.getYear()

  ' Convert 24-h to 12-h system
  hour12h% = hour
  if (hour = 0)
    hour12h% = 12
  else if (hour >= 13)
    hour12h% = abs(hour - 12)
  end if

  ' Get 12h system prefix
  half12h = "AM"
  if (hour >= 12)
    half12h = "PM"
  end if

  ' Left pad days
  dayPaddedStr = day.toStr()
  if (dayPaddedStr.len() = 1)
    dayPaddedStr = "0" + dayPaddedStr
  end if

  ' Left pad minutes
  minuteStr = minute.toStr()
  if (minuteStr.len() = 1)
    minuteStr = "0" + minuteStr
  end if

  resultStr = ""

  tokens = TokenizeDateTimeFormat(format)

  for each token in tokens
    if (token = "DD")
      ' Day of month: 01 02 ... 30 31
      resultStr += dayPaddedStr
    else if (token = "D")
      ' Day of month: 1 2 ... 30 31
      resultStr += day.toStr()
    else if (token = "MMM")
      ' Month: Jan Feb ... Nov Dec
      resultStr += GetShortMonthName(month)
    else if (token = "YYYY")
      ' Year: 1970 1971 ... 2029 2030
      resultStr += year.toStr()
    else if (token = "YY")
      ' Year: 70 71 ... 29 30
      resultStr += year.toStr().right(2)
    else if (token = "h")
      ' Hour: 1 2 ... 11 12
      resultStr += hour12h%.toStr()
    else if (token = "hh")
      ' Hour: 1 2 ... 11 12
      resultStr += hour.toStr()
    else if (token = "mm")
      ' Minute: 00 01 ... 58 59
      resultStr += minuteStr
    else if (token = "A")
      ' AM/PM: AM PM
      resultStr += half12h
    else
      resultStr += token
    end if
  end for

  return resultStr
end function

function TokenizeDateTimeFormat(format as string) as object
  chars = format.split("")

  tokens = []
  token = ""

  for i = 0 to (chars.count() - 1)
    char = chars[i]
    if (token.len() = 0)
      token = char
    else
      tokenLastChar = token.right(1)
      if (char = tokenLastChar)
        ' Append same char to token
        token += char
      else
        ' New character, append calculated token to a list of tokens
        ' and reset token with next characters
        tokens.push(token)
        token = char
      end if
    end if
  end for

  tokens.push(token)

  return tokens
end function

function GetShortMonthNameList() as object
  names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nav", "Dec"]
  return names
end function

function GetShortMonthName(index as integer) as string
  names = GetShortMonthNameList()
  return names[index - 1]
end function

function cdlGetMonthNameList() as object
  names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  return names
end function

function GetDurationString(totalSeconds = 0 as integer) as string
  remaining = totalSeconds
  hours = Int(remaining / 3600).ToStr()
  remaining = remaining mod 3600
  minutes = Int(remaining / 60).ToStr()

  if (hours <> "0")
    return hours + "h" + minutes + "m"
  else
    return minutes + "m"
  end if
end function

' "2011-09-22" -> roDateTime at midnight (UTC per Roku docs)
function DateFromYMD(dateStr as String) as Object
    if dateStr = invalid or dateStr = "" then return invalid
    parts = dateStr.split("-")
    if parts = invalid or parts.count() <> 3 then return invalid

    ' Build an ISO string Roku accepts
    iso = parts[0] + "-" + parts[1] + "-" + parts[2] + " 01:00:00.000"

    dt = CreateObject("roDateTime")
    dt.FromISO8601String(iso) 'Sets the time. Returns Void
    if dt <> invalid
        return dt
    else
        return invalid
    end if
end function