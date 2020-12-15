# Refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 0.02

style: """
    position:absolute
    margin: 0 auto
    top: 5%
    left: 0
    right: 0
    width: 400px
    color: #FFF
    min-height: 54px
    text-shadow: 1px 1px 2px rgba(#000, 0.4)

    #cover
        display:block
        text-align: center
    #cover img
        width: 80px
        height: 80px
        box-shadow: 1px 1px 2px rgba(#000, 0.4)
        border-radius: 50%

    #content
        padding: 10px 0
        width: 100%
        text-align:center
        overflow:hidden

    #content p
        width:1000px
        left: 50%;
        position: relative
        font-family: Helvetica Neue
        font-size: 16px
        font-weight: 200
        line-height: 20px
        margin:0 0 10px -500px
        padding:0

    #content span
        display: inline-block
        font-weight: 200
        font-size: 16px
        width: 240px
        overflow: hidden
        text-overflow: ellipsis
    #MusicPre
        display: inline-block
        margin-right:15px
    #MusicPre span
        display: inline-block
        width: 0
        height: 0
        border-top: 10px solid transparent
        border-right: 20px solid white
        border-bottom: 10px solid transparent
    #MusicNext
        display: inline-block
    #MusicNext span
        display: inline-block
        width: 0
        height: 0
        border-top: 10px solid transparent
        border-left: 20px solid white
        border-bottom: 10px solid transparent
    #MusicPause
        display: inline-block
        margin-right:10px
    #MusicPause span
        display: inline-block
        height:20px
        width:8px
        display: inline-block
        background:#FFF
        margin-right: 5px
    #MusicPlay
        margin-right:15px
        display: inline-block
        width: 0
        height: 0
        border-top: 10px solid transparent
        border-left: 20px solid white
        border-bottom: 10px solid transparent
"""

render: -> """
	<div id="music">
	    <div id="cover"></div>
	    <div id="content">
	        <p><span id="MusicArtist"></span></br><span id="MusicTitle"></span></p>
	        <a id="MusicPre"><span></span><span></span></a>
	        <a id="MusicPause"><span></span><span></span></a>
	        <a id="MusicPlay"></a>
	        <a id="MusicNext"><span></span><span></span></a>
	    </div>
	</div>
"""

command:    "osascript 'music.widget/music.scpt'"

afterRender: (domEl) ->
    $(domEl).on 'click', '#MusicPre', => @run "osascript -e 'tell application \"Music\" to previous track'"
    $(domEl).on 'click', '#MusicNext', => @run "osascript -e 'tell application \"Music\" to next track'"
    $(domEl).on 'click', '#MusicPause', => @run "osascript -e 'tell application \"Music\" to pause'"
    $(domEl).on 'click', '#MusicPlay', => @run "osascript -e 'tell application \"Music\" to play'"

update: (output, domEl) ->
    Musicvalues = output.split('~')

    if Musicvalues[3] == 'playing'
        $(domEl).find("#MusicPlay").hide()
        $(domEl).find("#MusicPause").show()
    else
        $(domEl).find("#MusicPause").hide()
        $(domEl).find("#MusicPlay").show()

    if $(domEl).find('#MusicTitle').text() == Musicvalues[0]
        return

    $(domEl).find('#MusicArtist').text("#{Musicvalues[1]}")
    $(domEl).find('#MusicTitle').text("#{Musicvalues[0]}")

    if Musicvalues[0] != " " && Musicvalues[1] != " "
        html = "<img src='music.widget/images/albumart.jpg'>"
        $(domEl).find('#cover').html("")
        $(domEl).find('#cover').html(html)
    else
        $(domEl).find('#cover').html("<img src='music.widget/images/default.png'>")

    if Musicvalues[0] == " " && Musicvalues[1] == " "
        $(domEl).find('#music').hide()
    else
        $(domEl).find('#music').show()
