# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$(window).on 'scroll', -> 
		if $(window).scrollTop() > $(document).height() - $(window).height() - 2000
			$("#more_products").click()
			$("#more_products").attr 'disabled', true

			console.log("test")
			delay = (ms, func) -> setTimeout func, ms
			delay 1000, -> $("#more_products").removeAttr 'disabled'
		return

$ ->
	$('#product_detail_modal').on 'scroll', -> 
		if $('#product_detail_modal').scrollTop() > $('#product_detail_modal_dialog').height() - 1500
			$("#more_products_modal").click()
			$("#more_products_modal").attr 'disabled', true

			console.log("test")
			delay = (ms, func) -> setTimeout func, ms
			delay 1000, -> $("#more_products_modal").removeAttr 'disabled'
		return

$ ->
	$('#product_detail_modal').on 'scroll', -> 
		if $(window).scrollTop() > $(document).height() - $(window).height() - 2000
			$("#more_products").click()
			$("#more_products").attr 'disabled', true

			console.log("test")
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
	$('#product_detail_modal').on 'hidden.bs.modal', ->
		alert("I want this to appear after the modal has closed!");
		console.log("tesst")


