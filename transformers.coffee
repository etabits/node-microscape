$ = require 'CSSselect'

getText = require './getText'
ts = {}


ts.noop = (dom) -> dom

ts.simpleTable = (trs) ->
	data = {}
	images = []
	for tr,c in trs
		th  = $('th', tr)
		td = $('td', tr)
		label = getText(th).replace(/:\ +$/, '');
		value = getText(td)


		if !value
			img = $('img', td)[0]
			if img
				images.push img.attribs.src
			continue

		if !label
			continue

		data[label.trim()]= value.trim()
	{
		data: data,
		images: images
	}


module.exports = ts