command: "date +'%l:%M:%p' && finger $(whoami) | egrep -o 'Name: [a-zA-Z0-9 ]{1,}' | cut -d ':' -f 2 | xargs echo"

# Refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 5

render: (o) -> """
  <div class='output'>
    <div class='welcome'>
    </div>
  </div>
"""

update: (output, domEl) ->
  # Seperate both lines of output
  rows = output.split('\n')

  # Grab only the first name
  names = rows[1].trim().split(' ')
  myname = names[0]

  # Break up time into arraw 0=Hours 1=Minutes 2=AM/PM
  times = rows[0].trim().split(':')
  hours = parseInt( times[0], 10 );

  # TODO: Clean up, but works for now
  message = 'Good night' if (times[2] == 'PM' && hours<13)
  message = 'Good evening' if (times[2] == 'PM' && hours<10)
  message = 'Good afternoon' if (times[2] == 'PM' && hours<5)
  message = 'Good afternoon' if (times[2] == 'PM' && hours==12)
  message = 'Good morning' if (times[2] == 'AM' && hours<13)
  message = 'Good night' if (times[2] == 'AM' && hours<4)
  message = 'Good night' if (times[2] == 'AM' && hours==12)

  # Show the welcome message
  $(domEl).find('.welcome').text message + ', ' + myname + ''

# Basic Style to center output
style: """
  top: 16%
  left: 10px
  color: #fff
  font-family: Helvetica Neue
  font-size: 25px
  font-weight: 200
  text-align: center
  width: 305px

  .welcome
    text-shadow: 1px 1px 2px rgba(#000, 0.4)

"""
