command: "sh ./scripts/bottom_bar/bottom_bar.sh"

refreshFrequency: '10s' # ms

render: (output) ->
  """
    <div>
      <div class='stats'></div>
    </div>
  """

style: """
  background-color: #2d2d2d;
  width: 100%;
  bottom: 0px;
  right: 0px;
  left 0px;
  height: 24px
  box-shadow: 5px 5px 5px 0px rgba(0,0,0,0.40);
  z-index: -1

  .stats
    display: flex
    justify-content: center
    align-items: center
    color: #66d9ef
    padding-top: 2px
"""

getMem: (mem) ->
  memNum = parseFloat(mem)
  memNum = memNum.toFixed(1)
  memString = String(memNum)

  if memNum < 10
    memString = '0' + memString

  return """
    <i class='icon-microsd brown' />
    &nbsp;
    <span class='white'>#{memString}%</span>
  """

getCPU: (cpu) ->
  cpuNum = parseFloat(cpu)

  # I have four cores, so I divide my CPU percentage by four to get the proper number
  cpuNum = cpuNum/8
  cpuNum = cpuNum.toFixed(1)
  cpuString = String(cpuNum)

  if cpuNum < 10
    cpuString = '0' + cpuString

  return """
    <i class='icon-cpu brown' />
    &nbsp;
    <span class='white'>#{cpuString}%</span>
  """

convertBytes: (bytes) ->
  kb = bytes / 1024
  return @usageFormat(kb)

usageFormat: (kb) ->
    mb = kb / 1024
    if mb < 0.01
      return "0.00MB"
    return "#{parseFloat(mb.toFixed(2))}MB"

getNetTraffic: (down, up) ->
  downString = @convertBytes(parseInt(down || 0))
  upString = @convertBytes(parseInt(up || 0))
  return """
    <div>
      <i class='icon-arrow-down-circle blue' />
      <span class='white'>#{downString}</span>
      <span>⎢</span>
      <i class='icon-arrow-up-circle orange' />
      <span class='white'>#{upString}</span>
    </div>
  """

getFreeSpace: (space) ->
  return """
    <i class='icon-floppy-disk brown' />
    &nbsp;
    <span class='white'>#{space}GB</span>
  """

getKubernetesContext: (context) ->
  return """
    <i class='icon-helm blue' />
    &nbsp;
    <span class='white'>#{context}</span>
  """

update: (output, domEl) ->

  # split the output of the script
  values = output.split('@')

  cpu = values[0]
  mem = values[1]
  down = values[2]
  up   = values[3]
  free = values[4].replace(/[^0-9]/g,'')
  kubernetesContext = values[5]

  # create an HTML string to be displayed by the widget
  htmlString = """
    #{@getNetTraffic(down, up)}
    <span>&nbsp⎢&nbsp</span>
    #{@getMem(mem)}
    <span>&nbsp⎢&nbsp</span>
    #{@getCPU(cpu)}
    <span>&nbsp⎢&nbsp</span>
    #{@getFreeSpace(free)}
    <span>&nbsp⎢&nbsp</span>
    #{@getKubernetesContext(kubernetesContext)}
  """

  $(domEl).find('.stats').html(htmlString)
