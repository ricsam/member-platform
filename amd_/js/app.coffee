
amd_requirejs.config
	baseUrl: '/amd_',
	paths:
		config: '/config.json'
		router: '/router.json'
		text: 'lib/text'
		coffee: 'lib/cs'
		apps: '/apps_'
		noext: 'lib/noext'

window.underscore = window._ = _ = require 'underscore'
window.Backbone = Backbone = require 'backbone'
window.jQuery = window.$ = Backbone.$ = require 'jquery'

require '../lib/backbone-deep-model.min.js'
require 'bootstrap'
require '../lib/metris.jquery.js'
require './AppEvents.coffee'
new (require('./AppView.coffee'))



$(window).bind "load resize", () ->
    if $(@).width() < 768
        $('div.sidebar-collapse').addClass('collapse')
    else
        $('div.sidebar-collapse').removeClass('collapse')



Links = require './links.coffee'

Routes = require './RoutesModel.coffee'

NProgress.start()

amd_requirejs ['text!router', 'text!config'], (str_router, str_config) ->
	# console.log str_r
	# return

	NProgress.done()

	config = JSON.parse str_config

	# window.AppEvents.on 'qr-input', do (config) -> (code) ->
		# window.AppEvents.trigger "render-apps", , el, config['qr-input-handler']
		# console.log 'will send the QR-code', code, config['qr-input-handler']

	parsed_router = JSON.parse(str_router)

	links = new Links parsed_router 

	window.routes = new Routes _.extend {}, parsed_router

	# x = JSON.parse str_router
	# console.log x

	links.buildMenu()
	links.route()

	$(document).delegate("a", "click", (evt) ->
		# Get the anchor href and protcol
		href = $(this).attr("href")
		protocol =  "#{this.protocol}//"

		# Ensure the protocol is not part of URL, meaning its relative.
		# Stop the event bubbling to ensure the link will not cause a page refresh.
		if href.slice(protocol.length) != protocol
			evt.preventDefault()

		# Note by using Backbone.history.navigate, router events will not be
		# triggered.  If this is a problem, change this to navigate on your
		# router.
		if href isnt 'no-link'
			Backbone.history.navigate(href.replace(/\#/g, ''), true)
	)






# amd_requirejs ['coffee!apps/register/app'], (mod) ->

# 	console.log mod()
