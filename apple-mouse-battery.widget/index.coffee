command: "ioreg -c AppleDeviceManagementHIDEventService | grep 'Magic Mouse' -A7 | grep BatteryPercent | sed 's/[a-z,A-Z, ,|,\",=]//g' | tail -1 | awk '{print $1}'"

# Refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 5

render: -> """
  <div class="batterymouse-magic">
	  <div class="title">Mouse</div>
	  <svg version="3.1" id="battery-mouse-magic"
	    xmlns="http://www.w3.org/2000/svg"
	    xmlns:xlink="http://www.w3.org/1999/xlink"
	    viewBox="0 0 200 28" >
	    <defs>
	      <clipPath id="cut-off-left">
	        <rect x="109" y="0" width="10" height="100" />
	      </clipPath>
	    </defs>
	    <rect id="hull" x="1" y="1" rx="3" ry="3" width="106" height="26" />
	    <circle id="tip" cx="106" cy="14" r="6"
	      clip-path="url(#cut-off-left)" />
	    <rect id="charge" x="4" y="4" rx="2" ry="2" height="20" />
	    <text id="text" x="8" y="18" style="font-size:12">##%</text>
	  </svg>
  </div>
"""

update: (output, domEl) ->
  text = $('#battery-mouse-magic #text')
  charge = parseInt(output) || 0

  if charge <= 25
    fill = '250,'+ 8 * charge + ',0'
  else
    fill = '91,158,91'
  fill = 'rgba('+fill+',1)'

  $('#battery-mouse-magic #charge').attr('width',charge)
  $('#battery-mouse-magic #charge').css('fill',fill)
  $('.batterymouse-magic').css('display',if charge == 0 then 'none' else 'block')

  text.text(charge + '%')

style: """
    main = rgba(#fff,1)
    color: main
    scale = .9
    opacity = 1

    top: 93%
    left: 70px
    font-family: Helvetica Neue
    font-size: 1em * scale
    text-shadow: 1px 1px 2px rgba(#000, 0.4)


    .title
      padding: 2px
      font-weight: 400
      font-size: 0.5em * scale
      text-transform: uppercase

    svg
      width: 160px * scale
      height: auto
      margin: 0
      opacity: opacity

    #hull
      fill: none
      stroke: main
      stroke-width: 2

    #tip
      fill: main

    #charge
      stroke-width: 2

    #text
      font-weight: bold
      fill: main

    #bolt
      position: absolute
      fill: main
      height: 25px
"""
