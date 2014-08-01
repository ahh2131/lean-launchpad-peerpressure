# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$(window).on 'scroll', ->
		if $(window).scrollTop() > $(document).height() - $(window).height() - 100
			$("#more_products").click()
			$("#more_products").attr 'disabled', true

			console.log("test")
			delay = (ms, func) -> setTimeout func, ms
			delay 500, -> $("#more_products").removeAttr 'disabled'
		return


$ ->
	$("#vigme-list-form").on 'submit', ->
		$("#close-list-modal").click()
		console.log("test")

