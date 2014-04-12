_ = require 'lodash'

go = (req, res) ->
	return res.send {text:"OK"}

init = (app) ->
  app.get '/test/go', go

module.exports = init: init