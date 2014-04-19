{parseString} = require 'xml2js'
http = require 'http'
request = require 'request'
util = require 'util'

agencyTag = "sf-muni"

requestAndParseUrl = (url, parseFunc, cb) ->
	request url, (err, resp, bod) ->
		if !err and resp.statusCode is 200
			parseFunc bod, (str) ->
				cb str
		else
			cb err

routeList = (req, res) ->
	url = "http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=#{agencyTag}"

	requestAndParseUrl url, parseRouteList, (str) ->
		return res.send {text: str}

parseRouteList = (xml, cb) ->
	parseString xml, (err, result) ->
		toReturn = ""
		for _route in result.body.route
			do (_route) ->
				toReturn += "#{_route.$.tag} -- #{_route.$.title}\n"
		cb toReturn

routeConfig = (req, res) ->
	route = req.param 'route'
	if route
		url = "http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=#{agencyTag}&r=#{route}"
		requestAndParseUrl url, parseRouteConfig, (str) ->
			return res.send {text:str}
	else
		return res.send {text:"No route specified"}

parseRouteConfig = (xml, cb) ->
	parseString xml, (err, result) ->
		console.log(util.inspect(result, {depth:null}))

		cb "ok"

init = (app) ->
  app.get '/muni/list_routes', routeList
  app.post '/muni/route_config', routeConfig

module.exports = init: init