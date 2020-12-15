# Forecast.io api key
apiKey: '990a44f37375dc897052751f33d5e9dc'

# Degree units; 'c' for celsius, 'f' for fahrenheit
unit: 'c'

# Icon set; 'black', 'white', and 'blue' supported
icon: 'white'

# Refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 5

exclude: "minutely,hourly,alerts,flags"

command: "echo {}"

makeCommand: (apiKey, location) ->
  "curl -sS 'https://api.darksky.net/forecast/#{apiKey}/#{location}?units=si&exclude=#{@exclude}'"

render: (o) -> """
	<article id="content">

		<!-- snippet -->
		<div id="snippet">
			<div id="icon">
			</div>

			<div id="temp">
			</div>
		</div>

		<!--phrase text box -->
		<h1>
		</h1>

		<!-- subline text box -->
		<h2>
		</h2>

	</article>
"""

afterRender: (domEl) ->
  geolocation.getCurrentPosition (e) =>
    coords     = e.position.coords
    [lat, lon] = [coords.latitude, coords.longitude]
    @command   = @makeCommand(@apiKey, "#{lat},#{lon}")

    @refresh()

update: (o, dom) ->
	# parse command json
	data = JSON.parse(o)
	console.log(@command)
	return unless data.currently?
	# get current temp from json
	t = data.currently.temperature

	# process condition data (1/2)
	s1 = data.currently.icon
	s1 = s1.replace(/-/g, "_")

	# snippet control

	# icon dump from android app
	$(dom).find('#icon').html('<img src="weather.widget/icon/' + @icon + '/' + s1 + '.png"></img>')

	if @unit == 'f'
		$(dom).find('#temp').html(Math.round(t * 9 / 5 + 32) + ' °')
	else
		$(dom).find('#temp').html(Math.round(t) + '°')

	# process condition data (2/2)
	s1 = s1.replace(/(day)/g, "")
	s1 = s1.replace(/(night)/g, "")
	s1 = s1.replace(/_/g, " ")
	s1 = s1.trim()

	# get relevant phrase
	@parseStatus(s1, t, dom)

# phrases dump from android app
parseStatus: (summary, temperature, dom) ->
	c = []
	s = []
	$.getJSON 'weather.widget/phrases.json', (data) ->
		$.each data.phrases, (key, val) ->
			# condition based
			if val.condition == summary
				if val.min < temperature
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

				if typeof val.min == 'undefined'
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

			# temp based
			if typeof val.condition == 'undefined'
				if val.min < temperature
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

				if typeof val.min == 'undefined'
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

		r = c[Math.floor(Math.random()*c.length)]

		title = r.title
		highlight = r.highlight[0]
		color = 'rgba(255,255,255, 0.6)'
		sub = r.subline
		nextTest = s[Math.floor(Math.random()*c.length)]

		text = title.replace(/\|/g, " ")

		c1 = new RegExp(highlight, "g")
		c2 = "<i style=\"color:" + color + "\">" + highlight + "</i>"

		text2 = text.replace(c1, c2)
		text3 = text2.replace(/>\?/g, ">")

		$(dom).find('h1').html text3
		$(dom).find('h2').html sub

# adapted from authenticweather.com
style: """
	width 35%
	top 24%
	left 1%
	font-family Helvetica Neue
	font-smooth always
	color #ffffff
	text-shadow 1px 1px 2px rgba(0,0,0,0.4)

	#snippet
		width 280px
		text-align center

	#icon
		img
			display inline-block
			max-height 80px

	#temp
		font-size 2em
		font-weight 200
		margin-bottom 5px

	h1
		text-align left
		font-size 2em
		font-weight 600
		line-height 0.6em
		letter-spacing -0.04em
		margin 0

	h2
		text-align left
		font-weight 500
		font-size 1em
		line-height 0.6em

	i
		font-style normal

"""
