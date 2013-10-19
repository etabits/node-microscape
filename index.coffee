request = require 'request'
htmlparser = require 'htmlparser2'
#domhandler = new htmlparser.DomHandler()
async = require 'async'
$ = require 'CSSselect'

cache = require('Simple-Cache').SimpleCache("./cache/");


exports = {}

class Scraper
	constructor: (@transformer, @cb) ->
		#console.log '!!', @transformer





	scrape: (url, selector, metas) ->
		metas ?= {url:url}
		#console.log(url, selector)
		self = this
		async.waterfall [
			# do the request
			(cb) ->
				cache.get url, (cacheCb) ->
					promise = request url, (err, response, body) ->
						#console.log 'Getting', url
						cacheCb(body)
				.fulfilled (data) ->
					#console.log(url, data.length)
					cb null, data

				
			# htmlparse the result
			(body, cb) -> 
				handler = new htmlparser.DomHandler cb

				parser = new htmlparser.Parser handler

				parser.write body
				parser.done()
			# select
			(dom, cb) ->
				cb $(selector, dom)

		], (dom) ->
			transformed = self.transformer dom
			self.cb transformed, metas
			


exports.$ = $
exports.Scraper = Scraper

exports.transformers = require './transformers'

module.exports = exports