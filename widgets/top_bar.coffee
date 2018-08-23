command: "sh ./scripts/top_bar/top_bar.sh"

refreshFrequency: 10000 # ms

render: (output) ->
  """
    <div>
      <div class="compstatus"></div>
    </div>
  """

style: """
  background-color: #2d2d2d;
  width: 100%;
  top: 0px;
  right: 0px;
  left 0px;
  height: 28px
  box-shadow: 5px 5px 5px 0px rgba(0,0,0,0.40);
  z-index: -1

  .compstatus
    position: absolute
    right: 18px
    top: 5px
    height: 13

    .charging
      font: 12px FontAwesome
      position: relative
      top: 0px
      right: -11px
      z-index: 1
  """
timeAndDate: (date, time) ->
  # returns a formatted html string with the date and time
  return """
    <i class='icon-calendar blue' />
    <span class='white'>#{date} ⎢ </span>
    <i class='icon-clock orange' />
    <span class='white'>#{time}</span>
  """

batteryStatus: (battery, state) ->
  #returns a formatted html string current battery percentage, a representative icon and adds a lighting bolt if the
  # battery is plugged in and charging
  icon = ''

  # If no battery exists, battery is only '%' character
  if state == 'AC' and battery == "%"
    return """
      <i class='icon-battery-plug2 green'>
    """

  batnum = parseInt(battery)
  if state == 'AC' and batnum >= 90
    icon = "<i class='icon-battery-plug-90 green'>"
  else if state == 'AC' and batnum >= 75 and batnum < 90
    icon = "<i class='icon-battery-plug-75 green'>"
  else if state == 'AC' and batnum >= 60 and batnum < 75
    icon = "<i class='icon-battery-plug-60 green'>"
  else if state == 'AC' and batnum >= 50 and batnum < 60
    icon = "<i class='icon-battery-plug-50 green'>"
  else if state == 'AC' and batnum >= 40 and batnum < 50
    icon = "<i class='icon-battery-plug-40 green'>"
  else if state == 'AC' and batnum >= 25 and batnum < 40
    icon = "<i class='icon-battery-plug-25 green'>"
  else if state == 'AC' and batnum >= 10 and batnum < 25
    icon = "<i class='icon-battery-plug-10 green'>"
  else if state == 'AC' and batnum < 10
    icon = "<i class='icon-battery-plug2 green'>"
  else if batnum >= 90
    icon = "<i class='icon-battery-90 green'>"
  else if batnum >= 75 and batnum < 90
    icon = "<i class='icon-battery-75 green'>"
  else if batnum >= 60 and batnum < 75
    icon = "<i class='icon-battery-60 green'>"
  else if batnum >= 50 and batnum < 60
    icon = "<i class='icon-battery-50 green'>"
  else if batnum >= 40 and batnum < 50
    icon = "<i class='icon-battery-40 green'>"
  else if batnum >= 25 and batnum < 40
    icon = "<i class='icon-battery-25 green'>"
  else if batnum >= 10 and batnum < 25
    icon = "<i class='icon-battery-10 green'>"
  else if batnum < 10
    icon = "<i class='icon-battery-empty green'>"

  return """
    #{icon}
    <span class='white'>#{batnum}%</span>
  """

getWifiStatus: (status, netName, netIP) ->
  if status == "Wi-Fi"
    return """
      &nbsp;
      <i class='icon-wifi-100 brown' />
      <span class='white'>#{netName}</span>
    """

  if status == 'USB 10/100/1000 LAN' or status == 'Apple USB Ethernet Adapter'
    return """
      <i class='icon-network2 brown' />
      <span class='white'>#{netIP}</span>
    """
  else
    return """
      <i class='icon-wifi-cross grey' />
      <span class='white'>--</span>
    """

getVolume: (str) ->
  vol = parseInt(str)

  if vol >= 0 && vol <= 25
    vol = 25
  else if vol > 25 && vol <= 50
    vol = 50
  else if vol > 50 && vol <= 75
    vol = 75
  else if vol > 75 <= 100
    vol = 100

  if str.trim() == "muted"
    return """
      <i class='icon-volume-cross brown' />
      <span class='white'>muted</span>
      &nbsp;
    """
  else
    return """
      <i class='icon-volume-#{vol} brown' />
      <span class='white'>#{str}&nbsp</span>
    """

update: (output, domEl) ->

  # split the output of the script
  values = output.split('@')

  time = values[0].replace /^\s+|\s+$/g, ""
  date = values[1]
  battery = values[2]
  isCharging = values[3]
  netStatus = values[4].replace /^\s+|\s+$/g, ""
  netName = values[5]
  netIP = values[6]
  volume = values[7]

  # create an HTML string to be displayed by the widget
  htmlString = @getVolume(volume) + "<span>" + " | " + "</span>" +
               @getWifiStatus(netStatus, netName, netIP) + "<span>" + " ⎢ " + "</span>" +
               @batteryStatus(battery, isCharging) + "<span>" + " ⎢ " + "</span>" +
               @timeAndDate(date,time)

  $(domEl).find('.compstatus').html(htmlString)
