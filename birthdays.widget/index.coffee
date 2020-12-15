# Must have icalBuddy installed
# Get it here: https://hasseg.org/icalBuddy/

command: '/usr/local/bin/icalBuddy -li 3 -ic "Birthdays" -iep "datetime,title" -ps "| – |" -nc -po "datetime,title" -df "%a" -nrd -b "" -ss"\t" eventsToday+7 >birthdays.widget/output.txt 2>&1; cat birthdays.widget/output.txt'

# Refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 5

style: """
  top: 79%
  left: 14px
  color: #fff
  width: 280px
  font-family: Helvetica Neue

  .output
    padding: 5px 10px
	text-shadow: 1px 1px 2px rgba(#000, 0.4)
    font-weight: 300

	.birthdays
	  margin: 0
	  padding: 0
	  text-align: left
	  text-shadow: 1px 1px 2px rgba(#000, 0.4)
	  font-family: Helvetica Neue
	  font-size: 13px
	  line-height: 1.6



"""

render: (output) ->  """
  <div class="output">
	 <pre class="birthdays">#{output}</pre>
  </div>
"""

update: (output) ->
  data = output.split('@implementation ?')
  html = data[2]
  $('.birthdays').html(html)