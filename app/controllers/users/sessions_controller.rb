class Users::SessionsController < Devise::SessionsController
 	def new
 		self.resource = resource_class.new(sign_in_params)
  		respond_to do |format|
  			format.html
  			format.js 
  		end
 	end
end