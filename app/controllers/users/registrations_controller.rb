class Users::RegistrationsController < Devise::RegistrationsController
 	def new
 		self.resource = resource_class.new(sign_up_params)
  		respond_to do |format|
  			format.html
  			format.js 
  		end
 	end
end