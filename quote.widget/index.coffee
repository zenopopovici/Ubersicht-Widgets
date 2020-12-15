command: 'curl -s "http://feeds.feedburner.com/brainyquote/QUOTEBR"'

# Refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 10

style: """
  bottom: 7%
  right: 0
  left: 0
  margin: 0 auto
  width: 61%
  color: #fff
  text-align: center
  text-shadow: 1px 1px 2px rgba(#000, 0.4)
  font-family: Helvetica Neue


  .output
    padding: 5px 10px
    width: 100%
    font-size: 38px
    font-weight: 200


  .author, .example, .example-meaning
    text-transform: capitalize
    font-size: 24px
  .author
    text-align: center

"""

render: (output) -> """
  <div class="output">
    <div class="quote"></div>
    <div class="author"></div>
  </div>
"""

update: (output, domEl) ->
  # Define constants, and extract the juicy html.
  dom = $(domEl)
  xml = $.parseXML(output)
  $xml = $(xml)
  description = $.parseHTML($xml.find('description').eq(1).text())
  $description = $(description)

 # Find the info we need, and inject it into the DOM.
  dom.find('.quote').html $xml.find('description').eq(2)
  dom.find('.author').html $xml.find('title').eq(2)


