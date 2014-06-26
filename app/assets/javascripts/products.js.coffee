# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	$(window).on 'scroll', ->
		if $(window).scrollTop() > $(document).height() - $(window).height() - 300
			$("#more_products").click()
		return