intraday = require 'intraday'
_ = require 'lodash'

quote = (req, res) ->
  symbol = req.param 'text'
  trigger = req.param 'trigger_word'

  if trigger?
    console.log "got a trigger #{trigger}"
    symbol = symbol.substr symbol.indexOf(trigger) + trigger.length + 1
    console.log "#{symbol}"

  if !symbol?
    return res.send {text:'no symbol'}

  intraday symbol, (err, data) ->
    if err?
      return res.send {text:err}

    lastQuote = _.last data

    resultStr = ""

    if lastQuote.high is lastQuote.low && lastQuote.high is lastQuote.close
      resultStr = symbol.toUpperCase() + " is trading at " + parseFloat(lastQuote.close)
    else
      resultStr = symbol.toUpperCase() + "is trading between " + parseFloat(lastQuote.high) + " and " + parseFloat(lastQuote.low)
    return res.send {text:resultStr}

init = (app) ->
  app.post '/stockapi/quote', quote

module.exports = init: init
