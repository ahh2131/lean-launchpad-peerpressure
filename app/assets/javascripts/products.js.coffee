# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$(window).on 'scroll', -> 
		if $(window).scrollTop() > $(document).height() - $(window).height() - 2000
			$("#more_products").click()
			$("#more_products").attr 'disabled', true
			delay = (ms, func) -> setTimeout func, ms
			delay 1000, -> $("#more_products").removeAttr 'disabled'
		return

$ ->
	$("#vigme-list-form").on 'submit', -> 
		$("#close-list-modal").click()

$ ->
	$('form#add_product_button').submit -> 
		console.log("test")
		$("#circularG").show()
		false

$ ->
	$('form#add_product_button').bind 'submit', (event) =>
		console.log("test")
		$("#circularG").show()
		false


$ ->
	$('#product_detail_modal').on 'scroll', -> 
		console.log("were good")
