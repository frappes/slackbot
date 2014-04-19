{parseString} = require 'xml2js'
http = require 'http'
request = require 'request'
util = require 'util'

agencyTag = "sf-muni"

go = (req, res) ->
	url = "http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=#{agencyTag}"

	request url, (err, resp, bod) ->
		if !err && resp.statusCode is 200
			routeList bod, (str) ->
				return res.send {text: str}
		else
			console.log(err)


	#return res.send {text:"OK"}

routeList = (xml, cb) ->
	parseString xml, (err, result) ->
		toReturn = ""
		for _route in result.body.route
			do (_route) ->
				toReturn += "#{_route.$.tag} -- #{_route.$.title}\n"
		cb toReturn

init = (app) ->
  app.get '/muni/go', go

module.exports = init: init